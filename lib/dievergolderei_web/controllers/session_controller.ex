defmodule DievergoldereiWeb.SessionController do
  use DievergoldereiWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Dievergolderei.Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> DievergoldereiWeb.Auth.login(user)
        |> put_flash(:info, "Erfolgreich angemeldet")
        |> redirect(to: Routes.page_path(conn, :admin))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> DievergoldereiWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
