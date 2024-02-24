defmodule Dievergolderei.ReleaseTest do
  use Dievergolderei.DataCase

  alias Dievergolderei.Release
  alias Dievergolderei.OpeningHours
  alias Dievergolderei.OpeningHours.Hours

  describe "release tasks" do
    # test "can roll back and migrate" do
    #   assert {:ok, _, _} = Release.rollback(Repo, 20190927222453)
    #   assert [{:ok, _, _}] = Release.migrate()
    # end

    test "can seed the database" do
      Release.seed()

      assert [%Hours{} | _] = OpeningHours.list_active_hours()
    end
  end
end
