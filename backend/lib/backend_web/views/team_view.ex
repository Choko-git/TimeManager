defmodule BackendWeb.TeamView do
  use BackendWeb, :view
  alias BackendWeb.TeamView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("show_create.json", %{team: team}) do
    %{id: team.id, name: team.name}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      users: render_many(team.users, BackendWeb.UserView, "show_simple.json")
    }
  end

  def render("teams.json", %{teams: teams}) do
    %{
      data:
        render_many(teams, TeamView, "team.json")
    }
  end
end
