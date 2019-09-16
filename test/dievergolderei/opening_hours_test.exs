defmodule Dievergolderei.OpeningHoursTest do
  use Dievergolderei.DataCase

  alias Dievergolderei.OpeningHours

  describe "hours" do
    alias Dievergolderei.OpeningHours.Hours

    @valid_attrs %{active: true, label: "some label", list_position: 42, times: "some times"}
    @update_attrs %{active: false, label: "some updated label", list_position: 43, times: "some updated times"}
    @invalid_attrs %{active: nil, label: nil, list_position: nil, times: nil}

    def hours_fixture(attrs \\ %{}) do
      {:ok, hours} =
        attrs
        |> Enum.into(@valid_attrs)
        |> OpeningHours.create_hours()

      hours
    end

    test "list_hours/0 returns all hours" do
      hours = hours_fixture()
      assert OpeningHours.list_hours() == [hours]
    end

    test "get_hours!/1 returns the hours with given id" do
      hours = hours_fixture()
      assert OpeningHours.get_hours!(hours.id) == hours
    end

    test "create_hours/1 with valid data creates a hours" do
      assert {:ok, %Hours{} = hours} = OpeningHours.create_hours(@valid_attrs)
      assert hours.active == true
      assert hours.label == "some label"
      assert hours.list_position == 42
      assert hours.times == "some times"
    end

    test "create_hours/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OpeningHours.create_hours(@invalid_attrs)
    end

    test "update_hours/2 with valid data updates the hours" do
      hours = hours_fixture()
      assert {:ok, %Hours{} = hours} = OpeningHours.update_hours(hours, @update_attrs)
      assert hours.active == false
      assert hours.label == "some updated label"
      assert hours.list_position == 43
      assert hours.times == "some updated times"
    end

    test "update_hours/2 with invalid data returns error changeset" do
      hours = hours_fixture()
      assert {:error, %Ecto.Changeset{}} = OpeningHours.update_hours(hours, @invalid_attrs)
      assert hours == OpeningHours.get_hours!(hours.id)
    end

    test "delete_hours/1 deletes the hours" do
      hours = hours_fixture()
      assert {:ok, %Hours{}} = OpeningHours.delete_hours(hours)
      assert_raise Ecto.NoResultsError, fn -> OpeningHours.get_hours!(hours.id) end
    end

    test "change_hours/1 returns a hours changeset" do
      hours = hours_fixture()
      assert %Ecto.Changeset{} = OpeningHours.change_hours(hours)
    end
  end
end
