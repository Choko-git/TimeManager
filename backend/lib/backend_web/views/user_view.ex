defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show_create.json", %{user: user}) do
    %{id: user.id,
      name: user.username,
      email: user.email,
      role: user.role,
      right_active: user.right_active
      }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      right_active: user.right_active,
      role: user.role,
      teams: render_many(user.teams, BackendWeb.TeamView, "show_create.json"),
      vacations: render_many(user.vacations, BackendWeb.VacationView, "vacation_bis.json"),
      workingtimes: render_many(user.workingtimes, BackendWeb.WorkingtimeView, "workingtime_bis.json")
      }
  end
end
