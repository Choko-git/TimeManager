defmodule BackendWeb.BelongController do
  use BackendWeb, :controller

  alias Backend.Belongs
  alias Backend.Belongs.Belong

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    belongs = Belongs.list_belongs()
    render(conn, "index.json", belongs: belongs)
  end

  def create_mult(conn, belong_params) do
    Enum.each(belong_params.user_ids, fn user_id ->
      Belongs.create_belong(%{team_id: belong_params.team_id, user_id: user_id})
    end)
  end

  def create(conn, belong_params) do
    IO.inspect(belong_params)

    with {:ok, %Belong{} = belong} <- Belongs.create_belong(belong_params) do
      render(conn, "show.json", belong: belong)
    end
  end

  def show(conn, %{"id" => id}) do
    belong = Belongs.get_belong!(id)
    render(conn, "show.json", belong: belong)
  end

  def update(conn, %{"id" => id, "belong" => belong_params}) do
    belong = Belongs.get_belong!(id)

    with {:ok, %Belong{} = belong} <- Belongs.update_belong(belong, belong_params) do
      render(conn, "show.json", belong: belong)
    end
  end

  def delete(conn, params) do
    Belongs.delete_belong(params)
    send_resp(conn, :no_content, "")
  end

  def get_belong_info(conn, params) do
    belongs = Belongs.get_info(params)
    render(conn, "index.json", belongs: belongs)
  end
end
