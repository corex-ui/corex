defmodule Corex.Install.EndpointDevPlugsTest do
  use ExUnit.Case, async: true

  alias Mix.Corex.Install.Web

  @phx_18 ~s"""
    plug Plug.Static,
      at: "/",
      from: :my_app,
      gzip: not code_reloading?,
      only: MyAppWeb.static_paths(),
      raise_on_missing_only: code_reloading?

    # Code reloading can be explicitly enabled under the
    # :code_reloader configuration of your endpoint.
    if code_reloading? do
      socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    end
  """

  test "inserts Corex.MCP when mcp is on" do
    out = Web.endpoint_mcp_apply(@phx_18, mcp: true)
    assert out =~ "  if Mix.env() == :dev do"
    assert out =~ "    plug Corex.MCP"
    assert out =~ "  if code_reloading? do"
  end

  test "no insertion when mcp is off" do
    out = Web.endpoint_mcp_apply(@phx_18, mcp: false)
    refute out =~ "Corex.MCP"
  end

  test "idempotent" do
    a = Web.endpoint_mcp_apply(@phx_18, mcp: true)
    b = Web.endpoint_mcp_apply(a, mcp: true)
    assert a == b
  end
end
