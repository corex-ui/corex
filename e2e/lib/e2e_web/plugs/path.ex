defmodule E2eWeb.Plugs.Path do
  @moduledoc "Assigns locale-stripped :path from the request (after `Localize.Plug`)."

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    path = E2eWeb.Path.strip_after_locale(conn.request_path)
    assign(conn, :path, path)
  end
end
