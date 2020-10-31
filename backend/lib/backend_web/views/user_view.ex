defmodule BackendWeb.UserView do
  use BackendWeb, :view
  alias BackendWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      right_active: user.right_active,
      role: user.role}
  end

  def render("sign.json", %{token: token, user: user}) do
    %{token: token, user: %{id: user.id,
      username: user.username,
      email: user.email,
      password: user.password,
      right_active: user.right_active,
      role: user.role}}
  end
end
