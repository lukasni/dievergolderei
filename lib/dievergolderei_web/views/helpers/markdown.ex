defmodule DievergoldereiWeb.Markdown do
  @moduledoc """
  Helper functions for editing and rendering markdown content
  """
  @options %Earmark.Options{
    breaks: true,
    gfm: true,
    smartypants: true
  }

  def markdown(content) do
    content
    |> Earmark.as_html!(@options)
    |> Dievergolderei.Sanitizer.sanitize()
    |> Phoenix.HTML.raw()
  end

  def markdown_editor(element_id) do
    """
    <link rel="stylesheet" href="//cdn.jsdelivr.net/simplemde/latest/simplemde.min.css">
    <script src="//cdn.jsdelivr.net/simplemde/latest/simplemde.min.js"></script>
    <script>var simplemde = new SimpleMDE({
      element: document.getElementById("#{element_id}"),
      spellChecker: false,
      hideIcons: ["heading"],
      showIcons: ["heading-2", "heading-3"]
    });</script>
    """
    |> Phoenix.HTML.raw()
  end
end
