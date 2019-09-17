defmodule Dievergolderei.Pages.StaticPage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "static_pages" do
    field :content, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(static_page, attrs) do
    static_page
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
