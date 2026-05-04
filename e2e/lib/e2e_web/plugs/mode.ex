defmodule E2eWeb.Plugs.Mode do
  @moduledoc """
  Reads the mode from the phx_mode cookie and puts it in assigns and session.
  Allows the server to render the correct mode in the initial HTML (no flash).
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    mode = conn.cookies["phx_mode"]

    conn
    |> assign(:mode, mode)
    |> put_session(:mode, mode)
  end
end
