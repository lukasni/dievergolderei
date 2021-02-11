defmodule DievergoldereiWeb.DateTimeHelpers do
  @moduledoc false

  def strftime(date_or_time_or_datetime, string_format, user_options \\ []) do
    opts = Keyword.merge(strftime_opts(), user_options)

    Calendar.strftime(date_or_time_or_datetime, string_format, opts)
  end

  def strftime_opts() do
    [
      preferred_date: "%d.%m.%Y",
      preferred_time: "%H:%M:%S",
      preferred_datetime: "%d.%m.%Y %H:%M:%S",
      am_pm_names: fn
        :am -> "am"
        :pm -> "pm"
      end,
      month_names: fn month ->
        {"Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September",
        "Oktober", "November", "Dezember"}
        |> elem(month - 1)
      end,
      day_of_week_names: fn day_of_week ->
        {"Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"}
        |> elem(day_of_week - 1)
      end,
      abbreviated_month_names: fn month ->
        {"Jan.", "Feb.", "Mär.", "Apr.", "Mai.", "Jun.", "Jul.", "Aug.", "Sep.", "Okt.", "Nov.", "Dez."}
        |> elem(month - 1)
      end,
      abbreviated_day_of_week_names: fn day_of_week ->
        {"Mo.", "Di.", "Mi.", "Do.", "Fr.", "Sa.", "So."} |> elem(day_of_week - 1)
      end
    ]
  end
end
