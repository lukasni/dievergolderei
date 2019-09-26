defmodule Dievergolderei.OpeningHours.Hours do
  use Ecto.Schema
  import Ecto.Query
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
    |> set_default_list_position()
    |> cast(attrs, [:label, :times, :active, :list_position])
    |> validate_required([:label, :times, :active])
  end

  defp set_default_list_position(%{list_position: nil} = hours) do
    max =
      __MODULE__
      |> order_by(desc: :list_position)
      |> limit(1)
      |> select([q], q.list_position)
      |> Dievergolderei.Repo.one()

    hours
    |> Map.update(:list_position, max + 1, fn val -> val || max + 1 end)
  end

  defp set_default_list_position(hours) do
    hours
  end
end
