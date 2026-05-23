defmodule E2eWeb.Plugs.DemoAuth do
  @moduledoc false

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts), do: conn
end
