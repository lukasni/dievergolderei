defmodule DievergoldereiWeb.Router do
  use DievergoldereiWeb, :router

  import DievergoldereiWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DievergoldereiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug Clacks
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
  end

  scope "/admin", DievergoldereiWeb do
    pipe_through [:browser, :require_authenticated_user, :hide_logo]

    import Phoenix.LiveDashboard.Router

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

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dievergolderei, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

    ## Authentication routes

  scope "/", DievergoldereiWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{DievergoldereiWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", DievergoldereiWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{DievergoldereiWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", DievergoldereiWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{DievergoldereiWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", DievergoldereiWeb do
  #   pipe_through :api
  # end
end
