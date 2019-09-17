defmodule DievergoldereiWeb.HoursController do
  use DievergoldereiWeb, :controller

  alias Dievergolderei.OpeningHours
  alias Dievergolderei.OpeningHours.Hours

  def index(conn, _params) do
    hours = OpeningHours.list_hours()
    render(conn, "index.html", hours: hours, title: "Übersicht Öffnungszeiten — Admin — ")
  end

  def new(conn, _params) do
    changeset = OpeningHours.change_hours(%Hours{})
    render(conn, "new.html", changeset: changeset, title: "Neue Öffnungszeiten — Admin — ")
  end

  def create(conn, %{"hours" => hours_params}) do
    case OpeningHours.create_hours(hours_params) do
      {:ok, _hours} ->
        conn
        |> put_flash(:info, "Hours created successfully.")
        |> redirect(to: Routes.hours_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, title: "Neue Öffnungszeiten — Admin — ")
    end
  end

  def edit(conn, %{"id" => id}) do
    hours = OpeningHours.get_hours!(id)
    changeset = OpeningHours.change_hours(hours)
    render(conn, "edit.html", hours: hours, changeset: changeset, title: "Öffnungszeiten Bearbeiten — Admin — ")
  end

  def update(conn, %{"id" => id, "hours" => hours_params}) do
    hours = OpeningHours.get_hours!(id)

    case OpeningHours.update_hours(hours, hours_params) do
      {:ok, _hours} ->
        conn
        |> put_flash(:info, "Hours updated successfully.")
        |> redirect(to: Routes.hours_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", hours: hours, changeset: changeset, title: "Öffnungszeiten Bearbeiten — Admin — ")
    end
  end

  def delete(conn, %{"id" => id}) do
    hours = OpeningHours.get_hours!(id)
    {:ok, _hours} = OpeningHours.delete_hours(hours)

    conn
    |> put_flash(:info, "Hours deleted successfully.")
    |> redirect(to: Routes.hours_path(conn, :index))
  end
end
