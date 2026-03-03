defmodule <%= @web_namespace %>.Plugs.Theme do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    themes = Application.get_env(:<%= @app_name %>, :themes, ["neo"])
    default_theme = List.first(themes) || "neo"
    theme =
      conn.cookies["phx_theme"]
      |> parse_theme(themes, default_theme)

    conn
    |> assign(:theme, theme)
    |> assign(:themes, themes)
    |> put_session(:theme, theme)
  end

  defp parse_theme(nil, _themes, default), do: default
  defp parse_theme(theme, themes, default) when theme in themes, do: theme
  defp parse_theme(_, _themes, default), do: default
end
