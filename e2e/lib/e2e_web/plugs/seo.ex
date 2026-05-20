defmodule E2eWeb.Plugs.SEO do
  @moduledoc false

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :seo, E2eWeb.SEO.default_from_conn(conn))
  end
end
