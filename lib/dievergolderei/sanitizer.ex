defmodule Dievergolderei.Sanitizer do
  alias Dievergolderei.Sanitizer.Scrubber

  def sanitize(html) do
    html
    |> HtmlSanitizeEx.Scrubber.scrub(Scrubber)
  end
end
