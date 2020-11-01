defmodule BackendWeb.VacationView do
  use BackendWeb, :view
  alias BackendWeb.VacationView

  def render("index.json", %{vacations: vacations}) do
    %{data: render_many(vacations, VacationView, "vacation.json")}
  end

  def render("show.json", %{vacation: vacation}) do
    %{data: render_one(vacation, VacationView, "vacation.json")}
  end


  def render("vacation_bis.json", %{vacation: vacation}) do
    %{id: vacation.id,
      start: vacation.start,
      end: vacation.end,
      accepted: vacation.accepted,
      seen: vacation.seen}
  end

  def render("vacation.json", %{vacation: vacation}) do
    %{id: vacation.id,
      start: vacation.start,
      end: vacation.end,
      accepted: vacation.accepted,
      seen: vacation.seen,
      user: render_one(vacation.user, BackendWeb.UserView, "show_create.json")}
  end
end
