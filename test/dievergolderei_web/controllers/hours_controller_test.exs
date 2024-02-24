defmodule DievergoldereiWeb.HoursControllerTest do
  use DievergoldereiWeb.ConnCase

  alias Dievergolderei.OpeningHours

  @create_attrs %{active: true, label: "some label", list_position: 42, times: "some times"}
  @update_attrs %{
    active: false,
    label: "some updated label",
    list_position: 43,
    times: "some updated times"
  }
  @invalid_attrs %{active: nil, label: nil, list_position: nil, times: nil}

  def fixture(:hours) do
    {:ok, hours} = OpeningHours.create_hours(@create_attrs)
    hours
  end

  test "requires authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, ~p"/admin/hours"),
        get(conn, ~p"/admin/hours/new"),
        get(conn, ~p"/admin/hours/#{"123"}/edit"),
        put(conn, ~p"/admin/hours/#{"123"}", hours: %{}),
        post(conn, ~p"/admin/hours/reorder?#{[id: 123, direction: "up"]}"),
        post(conn, ~p"/admin/hours", hours: %{}),
        delete(conn, ~p"/admin/hours/#{"123"}")
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "lists all hours", %{conn: conn} do
      conn = get(conn, ~p"/admin/hours")
      assert html_response(conn, 200) =~ "Öffnungszeiten"
    end
  end

  describe "new hours" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/admin/hours/new")
      assert html_response(conn, 200) =~ "Neue Öffnungszeiten"
    end
  end

  describe "create hours" do
    setup [:login_user]

    @tag login_as: "test@example.com"
    test "redirects to index when data is valid", %{conn: conn} do
      create_conn = post(conn, ~p"/admin/hours", hours: @create_attrs)

      assert redirected_to(create_conn) == ~p"/admin/hours"

      conn = get(conn, ~p"/admin/hours")
      assert html_response(conn, 200) =~ "some label"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/admin/hours", hours: @invalid_attrs)
      assert html_response(conn, 200) =~ "Neue Öffnungszeiten"
    end
  end

  describe "edit hours" do
    setup [:create_hours, :login_user]

    @tag login_as: "test@example.com"
    test "renders form for editing chosen hours", %{conn: conn, hours: hours} do
      conn = get(conn, ~p"/admin/hours/#{hours}/edit")
      assert html_response(conn, 200) =~ "Öffnungszeiten Bearbeiten"
    end
  end

  describe "update hours" do
    setup [:create_hours, :login_user]

    @tag login_as: "test@example.com"
    test "redirects when data is valid", %{conn: conn, hours: hours} do
      update_conn = put(conn, ~p"/admin/hours/#{hours}", hours: @update_attrs)
      assert redirected_to(update_conn) == ~p"/admin/hours"

      conn = get(conn, ~p"/admin/hours")
      assert html_response(conn, 200) =~ "some updated label"
    end

    @tag login_as: "test@example.com"
    test "renders errors when data is invalid", %{conn: conn, hours: hours} do
      conn = put(conn, ~p"/admin/hours/#{hours}", hours: @invalid_attrs)
      assert html_response(conn, 200) =~ "Öffnungszeiten Bearbeiten"
    end
  end

  describe "reorder hours" do
    setup [:create_orderable_hours, :login_user]

    @tag login_as: "test@example.com"
    test "reorders hours up successfully", %{conn: conn, second: second} do
      conn = post(conn, ~p"/admin/hours/reorder?#{[id: second.id, direction: "up"]}")
      assert redirected_to(conn) == ~p"/admin/hours"
    end

    @tag login_as: "test@example.com"
    test "reorders hours down successfully", %{conn: conn, first: first} do
      conn = post(conn, ~p"/admin/hours/reorder?#{[id: first.id, direction: "down"]}")
      assert redirected_to(conn) == ~p"/admin/hours"
    end
  end

  describe "delete hours" do
    setup [:create_hours, :login_user]

    @tag login_as: "test@example.com"
    test "deletes chosen hours", %{conn: conn, hours: hours} do
      conn = delete(conn, ~p"/admin/hours/#{hours}")
      assert redirected_to(conn) == ~p"/admin/hours"
    end
  end

  defp create_hours(_) do
    hours = fixture(:hours)
    {:ok, hours: hours}
  end

  defp create_orderable_hours(_) do
    {:ok, first} = OpeningHours.create_hours(%{@create_attrs | list_position: 0})
    {:ok, second} = OpeningHours.create_hours(%{@create_attrs | list_position: 1})

    {:ok, first: first, second: second}
  end
end
