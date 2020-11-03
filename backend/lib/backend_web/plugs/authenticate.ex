defmodule Backend.Plugs.Authenticate do
  import Plug.Conn
  import Ecto.Query

  def init(options) do
    options
  end

  def call(conn, _) do
    if conn.request_path !== "/api/users/log_in" do
      authorization = List.keyfind(conn.req_headers, "authorization", 0)
      token = Enum.at(String.split(elem(authorization, 1)), 1)
      result = validate_token(token)

      case result do
        :missing_token ->
          conn |> send_resp(401, "Missing valid API token") |> halt

        :invalid_token ->
          conn |> send_resp(401, "Invalid API token") |> halt

        {:authenticated, user} ->
          conn |> assign(:current_user, user)
      end
    else
      conn
    end
  end

  def validate_token(token) do
    case token do
      nil -> :missing_token
      _ -> assign_user(token)
    end
  end

  def assign_user(token) do
    result = Backend.Token.verify_and_validate(token)

    case result do
      {:error, message} ->
        :invalid_token

      {:ok, claims} ->
        user = %{
          "user_id" => claims["user_id"],
          "role" => claims["role"]
        }
        {:authenticated, user}
      _ ->
        :invalid_token
    end
  end
end
