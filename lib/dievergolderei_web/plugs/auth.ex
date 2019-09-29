defmodule DievergoldereiWeb.Auth do
  import Plug.Conn

  alias Dievergolderei.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      _user = conn.assigns[:current_user] ->
        conn

      user = user_id && Accounts.get_user!(user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
  end

  def logout(conn) do
    conn
    |> assign(:current_user, :nil)
    |> configure_session(drop: true)
  end
end
