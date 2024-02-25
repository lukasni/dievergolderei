defmodule DievergoldereiWeb.Components.Breadcrumbs do
  use Phoenix.Component

  slot :item, required: true do
    attr :to, :string
  end

  def breadcrumb(assigns) do
    ~H"""
    <nav>
      <span :for={item <- @item} class="after:content-['/'] last:after:content-['']">
        <.link :if={item[:to]} navigate={item.to} class="text-dvblue-500">
          <%= render_slot(item) %>
        </.link>
        <%= if !item[:to], do: render_slot(item) %>
      </span>
    </nav>
    """
  end
end
