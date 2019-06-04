defmodule MazingUi.Router do
  use MazingUi.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MazingUi do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/avatar_local", PageController, :avatar_local)
  end

  # Other scopes may use custom stacks.
  # scope "/api", MazingUi do
  #   pipe_through :api
  # end
end
