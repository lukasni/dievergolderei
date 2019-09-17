defmodule Dievergolderei.Util do
  @months %{
    1 => "Januar",
    2 => "Februar",
    3 => "März",
    4 => "April",
    5 => "Mai",
    6 => "Juni",
    7 => "Juli",
    8 => "August",
    9 => "September",
    10 => "Oktober",
    11 => "November",
    12 => "Dezember"
  }

  def month_name(month) when month in 1..12 do
    @months[month]
  end

  def first_day_of_month(%Date{year: year, month: month}) do
    {:ok, date} = Date.new(year, month, 1)
    date
  end
end
