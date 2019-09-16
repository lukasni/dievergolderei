defmodule Dievergolderei.OpeningHours.Hours do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hours" do
    field :active, :boolean, default: false
    field :label, :string
    field :list_position, :integer
    field :times, :string

    timestamps()
  end

  @doc false
  def changeset(hours, attrs) do
    hours
    |> cast(attrs, [:label, :times, :active, :list_position])
    |> validate_required([:label, :times, :active, :list_position])
  end
end
