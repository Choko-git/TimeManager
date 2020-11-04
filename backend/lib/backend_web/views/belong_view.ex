defmodule BackendWeb.BelongView do
  use BackendWeb, :view
  alias BackendWeb.BelongView

  def render("index.json", %{belongs: belongs}) do
    %{data: render_many(belongs, BelongView, "belong.json")}
  end

  def render("show.json", %{belong: belong}) do
    IO.puts "------------DFSDFHDFGDFGHDFDFFDFDFF"
    %{data: render_one(belong, BelongView, "belong.json")}
  end

  def render("belong.json", %{belong: belong}) do
    %{user_id: belong.user_id, team_id: belong.team_id}
  end
end
