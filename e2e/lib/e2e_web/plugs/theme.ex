defmodule E2eWeb.Plugs.Theme do
  @moduledoc """
  Reads the theme from the phx_theme cookie and puts it in assigns and session.
  Allows the server to render the correct theme in the initial HTML (no flash).
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    theme = conn.cookies["phx_theme"] || "neo"

    conn
    |> assign(:theme, theme)
    |> put_session(:theme, theme)
  end
end
