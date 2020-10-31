defmodule BackendWeb.BelongController do
  use BackendWeb, :controller

  alias Backend.Belongs
  alias Backend.Belongs.Belong

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    belongs = Belongs.list_belongs()
    render(conn, "index.json", belongs: belongs)
  end

  def create(conn,belong_params) do
    with {:ok, %Belong{} = belong} <- Belongs.create_belong(belong_params) do
      conn
      |> put_status(:created)
      |> render("show.json", belong: belong)
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

  def delete(conn, %{"id" => id}) do
    belong = Belongs.get_belong!(id)
    with {:ok, %Belong{}} <- Belongs.delete_belong(belong) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_belong_info(conn, params) do
    belongs = Belongs.get_info(params)
    render(conn, "index.json", belongs: belongs)
  end
end
