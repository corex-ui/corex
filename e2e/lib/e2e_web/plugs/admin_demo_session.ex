defmodule E2eWeb.Plugs.AdminDemoSession do
  @moduledoc false
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    case Plug.Conn.get_session(conn, "admin_demo_id") do
      id when is_binary(id) and id != "" ->
        conn

      _ ->
        Plug.Conn.put_session(conn, "admin_demo_id", Ecto.UUID.generate())
    end
  end
end
