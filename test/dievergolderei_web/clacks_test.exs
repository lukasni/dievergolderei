defmodule ExClacksTest do
  use ExUnit.Case
  use Plug.Test

  test "x-clacks-header gets added" do
    conn = conn(:get, "/") |> Clacks.call([])

    assert get_resp_header(conn, "x-clacks-overhead") == ["GNU Terry Pratchett"]
  end
end
