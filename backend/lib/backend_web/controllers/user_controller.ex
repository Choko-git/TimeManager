defmodule BackendWeb.UserController do
  use BackendWeb, :controller

  alias Backend.Users
  alias Backend.Users.User

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    hash = Bcrypt.add_hash(user_params["password"])
    user_params = Map.replace!(user_params, "password", hash[:password_hash])

    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def log_in(conn, user_params) do
    user = Users.get_by_email(user_params)
    res = Bcrypt.check_pass(user, user_params["password"], hash_key: :password, hide_user: true)
    check = elem(res, 0)
    if to_string(check) == "error" do
      conn
      |> put_status(:bad_request)
      |> text("Username or password incorrect")
    else
      date =
        DateTime.utc_now()
        |> Date.add(30)
      # csrf = get_csrf_token()
      extra_claims = %{"user_id" => user.id, "role" => user.role, "expiresAt" => date}
      token = BootstrapAuthentication.Token.generate_and_sign!(extra_claims)
      # conn
      # |> Plug.Conn.put_resp_cookie("token", token, http_only: false, secure: false, max_age: 604_800)
      # |> text(1)
      render(conn, "sign.json", %{token: token, csrf: csfr, user: user})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    IO.inspect(conn)

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_users_params(conn, params) do
    users = Users.get_users_by_params!(params)
    render(conn, "index.json", users: users)
  end
end
