defmodule DievergoldereiWeb.Components.Breadcrumbs do
  use Phoenix.Component

  slot :item, required: true do
    attr :to, :string
  end

  def breadcrumb(assigns) do
    ~H"""
    <nav>
      <.intersperse :let={item} enum={@item}>
        <:separator>
          <span class="text-grey-500">/</span>
        </:separator>
        <.link :if={item[:to]} navigate={item.to} class="text-dvblue-500">
          <%= render_slot(item) %>
        </.link>
        <%= if !item[:to], do: render_slot(item) %>
      </.intersperse>
    </nav>
    """
  end
end
