defmodule DievergoldereiWeb.Components.Cards do
  use Phoenix.Component

  import DievergoldereiWeb.CoreComponents, only: [icon: 1]

  slot :inner_block

  def card_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 xl:gap-8 mt-4 pb-16">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :header
  slot :inner_block
  slot :footer

  def card(assigns) do
    ~H"""
    <div class="flex flex-col bg-gray-200 bg-opacity-50 rounded">
      <header :if={@header != []} class="flex-none flex justify-between items-center p-2">
        <%= render_slot(@header) %>
      </header>

      <%= render_slot(@inner_block) %>

      <footer :if={@footer != []} class="flex-none flex items-center justify-between">
        <%= render_slot(@footer) %>
      </footer>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, default: nil

  def card_title(assigns) do
    ~H"""
    <h2 class="text-xl truncate">
      <%= @title %>
    </h2>
    <div :if={@subtitle} class="flex-none ml-2 text-gray-600">
      <%= @subtitle %>
    </div>
    """
  end

  attr :icon, :string, required: true
  attr :class, :string, default: "button-gray"
  attr :rest, :global, include: ~w(method navigate href patch replace)

  def card_button(assigns) do
    ~H"""
    <.link
      class={[
        "button flex-1 flex items-center justify-center",
        "rounded-none first:rounded-bl last:rounded-br border-r-0 last:border-r",
        @class
      ]}
      {@rest}
    >
      <.icon name={@icon} class="h-4 w-4" />
    </.link>
    """
  end
end
