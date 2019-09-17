defmodule Dievergolderei.PagesTest do
  use Dievergolderei.DataCase

  alias Dievergolderei.Pages

  describe "static_pages" do
    alias Dievergolderei.Pages.StaticPage

    @valid_attrs %{content: "some content", name: "some name"}
    @update_attrs %{content: "some updated content", name: "some updated name"}
    @invalid_attrs %{content: nil, name: nil}

    def static_page_fixture(attrs \\ %{}) do
      {:ok, static_page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pages.create_static_page()

      static_page
    end

    test "list_static_pages/0 returns all static_pages" do
      static_page = static_page_fixture()
      assert Pages.list_static_pages() == [static_page]
    end

    test "get_static_page!/1 returns the static_page with given id" do
      static_page = static_page_fixture()
      assert Pages.get_static_page!(static_page.id) == static_page
    end

    test "create_static_page/1 with valid data creates a static_page" do
      assert {:ok, %StaticPage{} = static_page} = Pages.create_static_page(@valid_attrs)
      assert static_page.content == "some content"
      assert static_page.name == "some name"
    end

    test "create_static_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_static_page(@invalid_attrs)
    end

    test "update_static_page/2 with valid data updates the static_page" do
      static_page = static_page_fixture()

      assert {:ok, %StaticPage{} = static_page} =
               Pages.update_static_page(static_page, @update_attrs)

      assert static_page.content == "some updated content"
      assert static_page.name == "some updated name"
    end

    test "update_static_page/2 with invalid data returns error changeset" do
      static_page = static_page_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_static_page(static_page, @invalid_attrs)
      assert static_page == Pages.get_static_page!(static_page.id)
    end

    test "delete_static_page/1 deletes the static_page" do
      static_page = static_page_fixture()
      assert {:ok, %StaticPage{}} = Pages.delete_static_page(static_page)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_static_page!(static_page.id) end
    end

    test "change_static_page/1 returns a static_page changeset" do
      static_page = static_page_fixture()
      assert %Ecto.Changeset{} = Pages.change_static_page(static_page)
    end
  end
end
