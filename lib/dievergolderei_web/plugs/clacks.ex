defmodule Clacks do
  import Plug.Conn, only: [put_resp_header: 3]

  # coveralls-ignore-start
  def init(opts), do: opts
  # coveralls-ignore-stop

  def call(conn, _opts) do
    conn
    |> put_resp_header("x-clacks-overhead", "GNU Terry Pratchett")
  end
end
