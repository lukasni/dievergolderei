defmodule DievergoldereiWeb.Router do
  use DievergoldereiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
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
    #get "/impressionen", PageController, :gallery
    live "/impressionen", GalleryLive
    get "/geschichte", PageController, :history
    get "/blog", PostController, :blog
    get "/blog/:month", PostController, :list
    get "/photos/:id", PhotoController, :render
  end

  scope "/admin", DievergoldereiWeb do
    pipe_through :browser

    get "/", PageController, :admin
    resources "/hours", HoursController, only: [:index, :new, :create, :edit, :update, :delete]
    get "/hours/reorder", HoursController, :reorder
    resources "/posts", PostController
    resources "/pages", StaticPageController, only: [:index, :create, :edit, :update, :show]
    resources "/photos", PhotoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", DievergoldereiWeb do
  #   pipe_through :api
  # end
end
