defmodule Clacks do
  import Plug.Conn, only: [put_resp_header: 3]

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> put_resp_header("x-clacks-overhead", "GNU Terry Pratchett")
  end
end
