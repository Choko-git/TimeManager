defmodule BackendWeb.TeamController do
  use BackendWeb, :controller

  alias Backend.Teams
  alias Backend.Teams.Team

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams()
    |> Repo.preload(:users)
    render(conn, "index.json", teams: teams)
  end

  def create(conn,team_params) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params)do
    BackendWeb.BelongController.create(conn, %{team_id: team.id, user_ids: team_params["user_ids"]})
    show(conn, %{"teamID" => team.id})
    end
  end

  def show(conn, %{"teamID" => id}) do
    teams = Teams.get_team!(id)
    render(conn, "teams.json", teams: teams)
  end

  def update(conn, team_params) do
    team = Teams.get_team!(team_params["id"])
    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  def delete(conn, %{"teamID" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_all_teams(conn,params) do
    teams = Teams.get_teams_with_users!()
    render(conn, "index.json", teams: teams)
  end

  def get_team_users(conn, params) do
    team = Teams.get_team_with_users!(params)
    render(conn, "show.json", team: team)
  end

end
