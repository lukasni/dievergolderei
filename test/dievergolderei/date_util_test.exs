defmodule Dievergolderei.UtilTest do
  use ExUnit.Case

  alias Dievergolderei.DateUtil

  describe "date" do
    test "first day of month is found" do
      dates = [~D[2019-01-01], ~D[2019-01-13], ~D[2019-01-31]]

      for d <- dates do
        assert DateUtil.first_day_of_month(d) == ~D[2019-01-01]
      end
    end

    test "german month names are resolved" do
      assert DateUtil.month_name(1) == "Januar"
      assert DateUtil.month_name(2) == "Februar"
      assert DateUtil.month_name(3) == "März"
      assert DateUtil.month_name(4) == "April"
      assert DateUtil.month_name(5) == "Mai"
      assert DateUtil.month_name(6) == "Juni"
      assert DateUtil.month_name(7) == "Juli"
      assert DateUtil.month_name(8) == "August"
      assert DateUtil.month_name(9) == "September"
      assert DateUtil.month_name(10) == "Oktober"
      assert DateUtil.month_name(11) == "November"
      assert DateUtil.month_name(12) == "Dezember"
    end
  end
end
