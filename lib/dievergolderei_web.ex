defmodule DievergoldereiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use DievergoldereiWeb, :controller
      use DievergoldereiWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """
  def static_paths,
    do:
      ~w(assets css fonts images js favicon.ico robots.txt android-chrome-192x192.png android-chrome-512x512.png
  apple-touch-icon.png browserconfig.xml favicon-16x16.png favicon-32x32.png mstile-150x150.png safari-pinned-tab.svg site.webmanifest)

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: DievergoldereiWeb,
        formats: [html: "View", json: "JSON"],
        layouts: [html: DievergoldereiWeb.Layouts]

      import Plug.Conn
      import DievergoldereiWeb.Gettext

      unquote(verified_routes())
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/dievergolderei_web/templates",
        namespace: DievergoldereiWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      # Include shared imports and aliases for views
      unquote(html_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {DievergoldereiWeb.LayoutView, "live.html"}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
      import Phoenix.LiveDashboard.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import DievergoldereiWeb.Gettext
    end
  end

  defp html_helpers do
    quote do
      # Use all HTML functionality
      import Phoenix.HTML
      import Phoenix.HTML.Form
      use PhoenixHTMLHelpers

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Core UI components and translation
      import DievergoldereiWeb.CoreComponents
      import DievergoldereiWeb.Components.Controls
      import DievergoldereiWeb.Components.Breadcrumbs
      import DievergoldereiWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      import DievergoldereiWeb.ErrorHelpers
      import DievergoldereiWeb.Markdown
      import DievergoldereiWeb.UploadHelpers
      alias DievergoldereiWeb.DateTimeHelpers, as: DT

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: DievergoldereiWeb.Endpoint,
        router: DievergoldereiWeb.Router,
        statics: ["uploads" | DievergoldereiWeb.static_paths()]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    # coveralls-ignore-start
    apply(__MODULE__, which, [])
    # coveralls-ignore-stop
  end
end
