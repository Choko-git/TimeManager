defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    # Routes pour Users
    resources "/users", UserController, except: [:index]
    get "/users", UserController, :all_users_params # team ou role.

    # Routes pour WorkingTime
    get "/workingtimes/:userID", WorkingtimeController, :get_all
    get "/workingtimes/:userID/:workingtimeID", WorkingtimeController, :get_one
    put "/workingtimes/:id", WorkingtimeController, :update
    post "/workingtimes/:userID", WorkingtimeController, :create
    delete "/workingtimes/:id",WorkingtimeController, :delete

    # Routes pour Clocks
    resources "/clocks", ClockController, except: [:index]
    post "/clocks/:userID", ClockController, :create
    get "/clocks/:userID", ClockController, :index

    # Routes pour Teams
    get "/teams/:teamID", TeamController, :show
    post "/teams/:team_name", TeamController, :create
    delete "/teams/:team_name", TeamController, :delete
    #update "/teams/:teamID", TeamController, :update

    # Routes pour Vacations
    resources "/vacations", VacationController, except: [:index]
    get "/vacations/:userID", VacationController, :get_all_vacations

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
