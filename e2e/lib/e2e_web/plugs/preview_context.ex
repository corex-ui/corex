defmodule E2eWeb.Plugs.PreviewContext do
  @moduledoc false

  def init(opts), do: opts

  def call(conn, _opts), do: conn
end
