defmodule Corex.MCP do
  @moduledoc """
  Dev-only Plug that mounts the Corex [Model Context Protocol](https://modelcontextprotocol.io)
  HTTP endpoint for AI tooling.

  Ships as the Hex package [`corex_mcp`](https://hex.pm/packages/corex_mcp). Add it to your app
  with `only: :dev`, then mount after `Plug.Static` and before the code reloader:

      if Mix.env() in [:dev, :test] do
        plug Corex.MCP
      end

  The endpoint is at `/corex/mcp`. Never enable this plug in `:prod` (initialization raises unless
  you pass `force: true`).

  See the [MCP guide](mcp.html) for tools, security, Cursor/Claude config, and Tableau Bandit wiring.
  """
  @behaviour Plug

  require Logger

  alias Corex.MCP.{Config, Server}

  def root, do: Application.get_env(:corex_mcp, :mcp_root, File.cwd!())

  @impl true
  def init(opts) when is_list(opts) do
    maybe_silence_mcp_server_logs()
    assert_not_prod!(opts)
    :ok = Server.init_tools()
    config = Config.build(opts)
    maybe_warn_remote_access!(config.allow_remote_access)
    config
  end

  def init(config) when is_map(config) do
    maybe_silence_mcp_server_logs()
    :ok = Server.init_tools()
    config = Config.build(config)
    maybe_warn_remote_access!(config.allow_remote_access)
    config
  end

  @remote_access_enabled_warning """
  Corex.MCP allow_remote_access is enabled. The MCP endpoint accepts connections from non-loopback addresses. Restrict network access with a firewall or VPN and never enable this in production.
  """

  defp maybe_warn_remote_access!(true), do: Logger.warning(@remote_access_enabled_warning)
  defp maybe_warn_remote_access!(_), do: :ok

  @impl true
  def call(%Plug.Conn{path_info: ["corex" | rest]} = conn, %Config{} = config) do
    conn
    |> validate!()
    |> Plug.Conn.put_private(:corex_mcp_config, config)
    |> Plug.forward(rest, Corex.MCP.Router, [])
    |> Plug.Conn.halt()
  end

  def call(conn, _config), do: conn

  defp maybe_silence_mcp_server_logs do
    if Application.get_env(:corex_mcp, :debug) || Application.get_env(:corex, :debug) do
      :ok
    else
      Logger.put_module_level(Server, :none)
    end
  end

  defp assert_not_prod!(opts) do
    if Mix.env() == :prod and not Keyword.get(opts, :force, false) do
      raise """
      plug Corex.MCP must not be enabled in production.

      Corex MCP is dev-only. Remove the plug from your endpoint or pass force: true \
      if you explicitly accept the security risk.
      """
    end
  end

  defp validate!(conn) do
    if live_reload_enabled?(conn) or request_body_parsed?(conn) do
      raise "plug Corex.MCP is running too late, after the request body has been parsed. " <>
              "Make sure to place \"plug Corex.MCP\" before the \"if code_reloading? do\" block"
    end

    conn
  end

  defp live_reload_enabled?(conn) do
    match?(%{phoenix_live_reload: true}, conn.private)
  end

  defp request_body_parsed?(conn) do
    not match?(%Plug.Conn.Unfetched{}, conn.body_params)
  end
end
