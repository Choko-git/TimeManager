defmodule Backend.Plugs.Authenticate do
  import Plug.Conn
  import Ecto.Query

  def init(options) do
    options
  end

  def call(conn, _) do
    if conn.request_path !== "/api/users/log_in" && conn.request_path !== "/api/users" do
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
    {:ok, claims} = Backend.Token.verify_and_validate(token)

    case claims do
      nil ->
        :invalid_token

      _ ->
        dateArray = String.split(claims["expiresAt"], "-")
        {:ok, date} =
          Date.new(
            String.to_integer(Enum.at(dateArray, 0)),
            String.to_integer(Enum.at(dateArray, 1)),
            String.to_integer(Enum.at(dateArray, 2))
          )
        checkDate = Date.compare(Date.utc_today(), date)
        case checkDate do
          :gt ->
            :invalid_token

          :lt ->
            user = %{
              "user_id" => claims["user_id"],
              "role" => claims["role"],
              "expiresAt" => claims["expiresAt"]
            }

            {:authenticated, user}
        end
    end
  end
end
