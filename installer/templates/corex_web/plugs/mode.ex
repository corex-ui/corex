defmodule <%= @web_namespace %>.Plugs.Mode do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    mode =
      conn.cookies["phx_mode"]
      |> parse_mode()

    conn
    |> assign(:mode, mode)
    |> put_session(:mode, mode)
  end

  defp parse_mode("dark"), do: "dark"
  defp parse_mode(_), do: "light"
end
