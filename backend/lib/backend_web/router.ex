defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Backend.Plugs.Authenticate

  end

  scope "/api", BackendWeb do
    pipe_through :api

    # Routes pour Users
    resources "/users", UserController, except: [:index]
    post "/users/log_in", UserController, :log_in
    get "/users/log_in/token", UserController, :log_in_with_token
    get "/users", UserController, :get_users_params # team ou role.
    put "/users/userID", UserController, :update

    # Routes pour WorkingTime
    get "/workingtimes/:userID", WorkingtimeController, :get_all
    get "/workingtimes/:userID/:workingtimeID", WorkingtimeController, :get_one
    put "/workingtimes/:id", WorkingtimeController, :update
    post "/workingtimes", WorkingtimeController, :create
    delete "/workingtimes/:id",WorkingtimeController, :delete

    # Routes pour Clocks
    get "/clocks/:userID", ClockController, :show
    post "/clocks", ClockController, :create
    get "/clocks/:userID", ClockController, :get_all
    put "/clocks/:id", ClockController, :update
    get "/clocks/:userID/:clockID", ClockController, :get_one
    delete "/clocks/:id", ClockController, :delete

    # Routes pour Teams
    get "/teams/:teamID", TeamController, :show
    post "/teams", TeamController, :create
    delete "/teams/:teamID", TeamController, :delete
    put "/teams", TeamController, :update
    get "/teams", TeamController, :get_all_teams

    # Routes pour Vacations
    get "/vacations/:userID", VacationController, :show
    get "/vacations/:userID", VacationController, :get_all_vacations
    get "/vacations/:userID/:vacationID", VacationController, :get_vacation
    post "/vacations", VacationController, :create
    delete "/vacations/:id", VacationController, :delete
    put "/vacations/:id", VacationController, :update
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
