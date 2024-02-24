defmodule DievergoldereiWeb.RequireLogin do
  @moduledoc """
  Module plug for requiring a logged-in user
  """
  use DievergoldereiWeb, :verified_routes
  import Plug.Conn
  # coveralls-ignore-start
  def init(opts), do: opts

  # coveralls-ignore-stop

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login benötigt")
        |> Phoenix.Controller.redirect(to: ~p"/sessions/new")
        |> halt()

      _user ->
        conn
    end
  end
end
