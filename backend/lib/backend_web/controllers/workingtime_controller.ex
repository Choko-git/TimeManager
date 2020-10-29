defmodule BackendWeb.WorkingtimeController do
  use BackendWeb, :controller

  alias Backend.WorkingTime
  alias Backend.WorkingTime.Workingtime

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    workingtimes = WorkingTime.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"workingtime" => workingtime_params}) do
    with {:ok, %Workingtime{} = workingtime} <- WorkingTime.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.workingtime_path(conn, :show, workingtime))
      |> render("show.json", workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id}) do
    workingtime = WorkingTime.get_workingtime!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = WorkingTime.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- WorkingTime.update_workingtime(workingtime, workingtime_params) do
      render(conn, "show.json", workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = WorkingTime.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- WorkingTime.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_all(conn, params) do
    working_times = WorkingTimes.get_working_time_all(params)
    render(conn, "index.json", working_times: working_times)
  end

  def get_one(conn,params) do
      working_time = WorkingTimes.get_working_time_one(params)
      render(conn, "show.json", working_time: working_time)
  end
end
