defmodule DievergoldereiWeb.ShopView do
  use DievergoldereiWeb, :view

  alias Decimal, as: D

  defp format_chf(%D{} = number) do
    case D.compare(number, D.round(number)) do
      :eq -> "CHF #{number}.–"
      _ -> "CHF #{D.round(number, 2)}"
    end
  end
end
