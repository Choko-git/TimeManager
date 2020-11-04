defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Backend.Plugs.Authenticate

  end

  scope "/api", BackendWeb do
    pipe_through :api

    # Routes pour Users

    #resources "/users", UserController, except: [:index]
    delete "/users/:id", UserController, :delete
    post "/users", UserController, :create
    get "/users", UserController, :get_all_users
    get "/users/get/me", UserController, :get_me
    get "/users/:user_id", UserController, :get_user_teams
    post "/users/log_in", UserController, :log_in
    get "/users/log_in/token", UserController, :log_in_with_token
    put "/users/userID", UserController, :update
    post "/sign_up", UserController, :log_in

    # Routes pour WorkingTime
    #get "/workingtimes/:userID", WorkingtimeController, :get_all
    get "/workingtimes/:userID/:workingtimeID", WorkingtimeController, :get_one
    put "/workingtimes/:id", WorkingtimeController, :update
    post "/workingtimes", WorkingtimeController, :create
    delete "/workingtimes/:id",WorkingtimeController, :delete

    # Routes pour Clocks
    # get "/clocks/:userID", ClockController, :show
    post "/clocks", ClockController, :create
    get "/clocks/:userID", ClockController, :get_all
    put "/clocks/:id", ClockController, :update
    get "/clocks/:userID/:clockID", ClockController, :get_one
    delete "/clocks/:id", ClockController, :delete

    # Routes pour Teams
    get "/teams/:teams_id", TeamController, :get_team_users
    post "/teams", TeamController, :create
    delete "/teams/:teamID", TeamController, :delete
    put "/teams", TeamController, :update
    get "/teams", TeamController, :get_all_teams

    # Routes pour Vacations
    get "/vacations/:userID", VacationController, :show
    #get "/vacations/:userID", VacationController, :get_all_vacations
    get "/vacations/:userID/:vacationID", VacationController, :get_vacation
    post "/vacations", VacationController, :create
    delete "/vacations/:id", VacationController, :delete
    put "/vacations/:id", VacationController, :update

    # Routes pour belongs // Utilisateurs -> Team
    get "/belongs", BelongController, :index
    post "/belongs/:team_id/:user_id", BelongController, :create
    delete "/belongs/:id", BelongController, :delete
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: BackendWeb.Telemetry
    end
  end
end
