defmodule E2eWeb.Plugs.Theme do
  @moduledoc """
  Reads the theme from the phx_theme cookie and puts it in assigns and session.
  Allows the server to render the correct theme in the initial HTML (no flash).
  """
  import Plug.Conn

  @valid_themes ~w(neo uno duo leo)

  def init(opts), do: opts

  def call(conn, _opts) do
    theme =
      conn.cookies["phx_theme"]
      |> parse_theme()

    conn
    |> assign(:theme, theme)
    |> put_session(:theme, theme)
  end

  defp parse_theme(nil), do: "neo"
  defp parse_theme(theme) when theme in @valid_themes, do: theme
  defp parse_theme(_), do: "neo"
end
