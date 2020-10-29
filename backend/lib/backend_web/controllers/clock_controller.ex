defmodule BackendWeb.ClockController do
  use BackendWeb, :controller

  alias Backend.Clocks
  alias Backend.Clocks.Clock

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    clock = Clocks.list_clocks()
    render(conn, "index.json", clock: clock)
  end

  def create(conn, clock_params) do
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, id) do
    clock = Clocks.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, clock_params) do
    clock = Clocks.get_clock!(clock_params["id"])

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_one(conn,params) do
    clock = Clocks.get_clock_one(params)
    render(conn, "show.json", clock: clock)
  end

  def get_all(conn,params) do
    clocks = Clocks.get_clocks(params)
    render(conn, "index.json", clocks: clocks)
  end
end
