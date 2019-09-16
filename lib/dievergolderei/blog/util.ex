defmodule Dievergolderei.Blog.Util do
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
  def date_to_month_year_string(%Date{month: month, year: year}) do
    "#{@months[month]} #{year}"
  end

  def month_links(%Date{month: month, year: year} = date) do
    {date_to_month_year_string(date), "#{year}-#{month}"}
  end
end
