defmodule DievergoldereiWeb.Router do
  use DievergoldereiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DievergoldereiWeb.Auth
    plug Clacks
  end

  pipeline :admin do
    plug :put_layout, {DievergoldereiWeb.LayoutView, "admin.html"}
    plug DievergoldereiWeb.RequireLogin
  end

  scope "/", DievergoldereiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/kontakt", PageController, :contact
    get "/shop", PageController, :shop
    get "/impressionen", PageController, :gallery
    get "/geschichte", PageController, :history
    get "/blog", PostController, :blog
    get "/blog/:month", PostController, :list
    get "/uploads/:id", PhotoController, :serve
    get "/uploads/shop/:id", ShopController, :serve
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/admin", DievergoldereiWeb do
    pipe_through [:browser, :admin]

    get "/", PageController, :admin
    post "/hours/reorder", HoursController, :reorder
    resources "/hours", HoursController, only: [:index, :new, :create, :edit, :update, :delete]
    resources "/posts", PostController
    resources "/pages", StaticPageController, only: [:index, :create, :edit, :update, :show]
    resources "/photos", PhotoController
    resources "/shop", ShopController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", DievergoldereiWeb do
  #   pipe_through :api
  # end
end
