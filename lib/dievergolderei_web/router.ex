defmodule DievergoldereiWeb.Router do
  use DievergoldereiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DievergoldereiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/kontakt", PageController, :contact
  end

  # Other scopes may use custom stacks.
  # scope "/api", DievergoldereiWeb do
  #   pipe_through :api
  # end
end
