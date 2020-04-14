defmodule Dievergolderei do
  @moduledoc """
  Dievergolderei keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def version() do
    Application.spec(:dievergolderei, :vsn)
    |> to_string()
  end
end
