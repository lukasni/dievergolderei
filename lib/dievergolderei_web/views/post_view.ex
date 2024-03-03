defmodule DievergoldereiWeb.PostView do
  use DievergoldereiWeb, :html

  embed_templates "../templates/post/*"

  attr :month, Date
  attr :rest, :global

  def month_link(assigns) do
    assigns =
      assign(assigns, :slug, "#{assigns.month.year}-#{assigns.month.month}")

    ~H"""
    <.link
      navigate={~p"/blog/#{@slug}"}
      {@rest}
    >
      <%= Dievergolderei.DateUtil.month_name(@month.month) %> <%= @month.year %>
    </.link>
    """
  end
end
