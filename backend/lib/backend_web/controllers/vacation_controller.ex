defmodule BackendWeb.VacationController do
  use BackendWeb, :controller

  alias Backend.Vacations
  alias Backend.Vacations.Vacation

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    vacations = Vacations.list_vacations()
    render(conn, "index.json", vacations: vacations)
  end

  def create(conn, %{"vacation" => vacation_params}) do
    with {:ok, %Vacation{} = vacation} <- Vacations.create_vacation(vacation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.vacation_path(conn, :show, vacation))
      |> render("show.json", vacation: vacation)
    end
  end

  def show(conn, %{"id" => id}) do
    vacation = Vacations.get_vacation!(id)
    render(conn, "show.json", vacation: vacation)
  end

  def update(conn, %{"id" => id, "vacation" => vacation_params}) do
    vacation = Vacations.get_vacation!(id)

    with {:ok, %Vacation{} = vacation} <- Vacations.update_vacation(vacation, vacation_params) do
      render(conn, "show.json", vacation: vacation)
    end
  end

  def delete(conn, %{"id" => id}) do
    vacation = Vacations.get_vacation!(id)

    with {:ok, %Vacation{}} <- Vacations.delete_vacation(vacation) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_all_vacations(conn, params) do
    vacation = Vacations.get_all_vacations(params)
    render(conn, "index.json", vacation: vacation)
  end

end
