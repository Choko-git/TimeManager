defmodule BackendWeb.WorkingtimeView do
  use BackendWeb, :view
  alias BackendWeb.WorkingtimeView

  def render("index.json", %{workingtime: workingtime}) do
    %{data: render_many(workingtime, WorkingtimeView, "workingtime.json")}
  end

  def render("show.json", %{workingtime: workingtime}) do
    %{data: render_one(workingtime, WorkingtimeView, "workingtime.json")}
  end

  def render("workingtime.json", %{workingtime: workingtime}) do
    %{id: workingtime.id,
      start: workingtime.start,
      end: workingtime.end}
  end
end
