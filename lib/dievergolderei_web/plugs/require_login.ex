defmodule DievergoldereiWeb.RequireLogin do
  import Plug.Conn

  alias DievergoldereiWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login benötigt")
        |> Phoenix.Controller.redirect(to: Routes.session_path(conn, :new))
        |> halt()

      _user ->
        conn
    end
  end
end
