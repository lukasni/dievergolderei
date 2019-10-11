defmodule Dievergolderei.FileUtil do
  def hash(filename, algorithm) when is_binary(filename) do
    filename
    |> File.stream!([], 2048)
    |> hash(algorithm)
  end

  def hash(chunks, algorithm) do
    chunks
    |> Enum.reduce(
      :crypto.hash_init(algorithm),
      &:crypto.hash_update(&2, &1)
    )
    |> :crypto.hash_final()
    |> Base.encode16()
    |> String.downcase()
  end
end
