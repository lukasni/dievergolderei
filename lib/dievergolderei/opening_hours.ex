defmodule Dievergolderei.OpeningHours do
  @moduledoc """
  The OpeningHours context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Dievergolderei.Repo

  alias Dievergolderei.OpeningHours.Hours

  @doc """
  Returns the list of hours sorted by list_position in ascending order.

  ## Examples

      iex> list_hours()
      [%Hours{}, ...]

  """
  def list_hours do
    Hours
    |> order_by(asc: :list_position)
    |> Repo.all()
  end

  @doc """
  Returns the list of active hours sorted by list_position in ascending order.

  ## Examples

      iex> list_active_hours()
      [%Hours{}, ...]

  """
  def list_active_hours() do
    Hours
    |> where(active: true)
    |> order_by(asc: :list_position)
    |> Repo.all()
  end

  @doc """
  Gets a single hours.

  Raises `Ecto.NoResultsError` if the Hours does not exist.

  ## Examples

      iex> get_hours!(123)
      %Hours{}

      iex> get_hours!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hours!(id), do: Repo.get!(Hours, id)

  @doc """
  Creates a hours.

  ## Examples

      iex> create_hours(%{field: value})
      {:ok, %Hours{}}

      iex> create_hours(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hours(attrs \\ %{}) do
    %Hours{}
    |> Hours.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hours.

  ## Examples

      iex> update_hours(hours, %{field: new_value})
      {:ok, %Hours{}}

      iex> update_hours(hours, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hours(%Hours{} = hours, attrs) do
    hours
    |> Hours.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Hours.

  ## Examples

      iex> delete_hours(hours)
      {:ok, %Hours{}}

      iex> delete_hours(hours)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hours(%Hours{} = hours) do
    Repo.delete(hours)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hours changes.

  ## Examples

      iex> change_hours(hours)
      %Ecto.Changeset{source: %Hours{}}

  """
  def change_hours(%Hours{} = hours) do
    Hours.changeset(hours, %{})
  end

  def change_order(%Hours{} = hours, :up) do
    prev =
      Hours
      |> where([q], q.list_position < ^hours.list_position)
      |> order_by(desc: :list_position)
      |> limit(1)
      |> Repo.one()
      |> IO.inspect()

    case prev do
      nil -> {:ok, :no_change}
      prev ->
        Multi.new
        |> Multi.update(:new, Hours.changeset(hours, %{list_position: prev.list_position}))
        |> Multi.update(:prev, Hours.changeset(prev, %{list_position: prev.list_position + 1}))
        |> Repo.transaction()
    end
  end

  def change_order(%Hours{} = hours, :down) do
    prev =
      Hours
      |> where([q], q.list_position > ^hours.list_position)
      |> order_by(asc: :list_position)
      |> limit(1)
      |> Repo.one()
      |> IO.inspect()

    case prev do
      nil -> {:ok, :no_change}
      prev ->
        Multi.new
        |> Multi.update(:prev, Hours.changeset(prev, %{list_position: hours.list_position}))
        |> Multi.update(:new, Hours.changeset(hours, %{list_position: hours.list_position + 1}))
        |> Repo.transaction()
    end
  end
end
