defmodule DievergoldereiWeb.HoursControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.OpeningHours

  @create_attrs %{active: true, label: "some label", list_position: 42, times: "some times"}
  @update_attrs %{active: false, label: "some updated label", list_position: 43, times: "some updated times"}
  @invalid_attrs %{active: nil, label: nil, list_position: nil, times: nil}

  def fixture(:hours) do
    {:ok, hours} = OpeningHours.create_hours(@create_attrs)
    hours
  end

  describe "index" do
    test "lists all hours", %{conn: conn} do
      conn = get(conn, Routes.hours_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hours"
    end
  end

  describe "new hours" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.hours_path(conn, :new))
      assert html_response(conn, 200) =~ "New Hours"
    end
  end

  describe "create hours" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.hours_path(conn, :create), hours: @create_attrs)

      assert redirected_to(conn) == Routes.hours_path(conn, :index)

      conn = get(conn, Routes.hours_path(conn, :index))
      assert html_response(conn, 200) =~ "some label"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.hours_path(conn, :create), hours: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Hours"
    end
  end

  describe "edit hours" do
    setup [:create_hours]

    test "renders form for editing chosen hours", %{conn: conn, hours: hours} do
      conn = get(conn, Routes.hours_path(conn, :edit, hours))
      assert html_response(conn, 200) =~ "Edit Hours"
    end
  end

  describe "update hours" do
    setup [:create_hours]

    test "redirects when data is valid", %{conn: conn, hours: hours} do
      conn = put(conn, Routes.hours_path(conn, :update, hours), hours: @update_attrs)
      assert redirected_to(conn) == Routes.hours_path(conn, :index)

      conn = get(conn, Routes.hours_path(conn, :index))
      assert html_response(conn, 200) =~ "some updated label"
    end

    test "renders errors when data is invalid", %{conn: conn, hours: hours} do
      conn = put(conn, Routes.hours_path(conn, :update, hours), hours: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Hours"
    end
  end

  describe "delete hours" do
    setup [:create_hours]

    test "deletes chosen hours", %{conn: conn, hours: hours} do
      conn = delete(conn, Routes.hours_path(conn, :delete, hours))
      assert redirected_to(conn) == Routes.hours_path(conn, :index)
    end
  end

  defp create_hours(_) do
    hours = fixture(:hours)
    {:ok, hours: hours}
  end
end
