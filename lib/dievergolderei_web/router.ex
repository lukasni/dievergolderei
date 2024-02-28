defmodule DievergoldereiWeb.Router do
  use DievergoldereiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DievergoldereiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug DievergoldereiWeb.Auth
    plug Clacks
  end

  pipeline :admin do
    plug DievergoldereiWeb.RequireLogin
    plug :hide_logo
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
    live_dashboard "/dashboard", metrics: DievergoldereiWeb.Telemetry
  end

  def hide_logo(conn, _opts) do
    Plug.Conn.assign(conn, :hide_logo, true)
  end

  # Other scopes may use custom stacks.
  # scope "/api", DievergoldereiWeb do
  #   pipe_through :api
  # end
end
