defmodule Corex.MCP do
  @moduledoc false
  @behaviour Plug

  require Logger

  alias Corex.MCP.Server

  @doc """
  Returns the project root for MCP path relativization.
  """
  def root, do: Application.get_env(:corex, :mcp_root, File.cwd!())

  @impl true
  def init(opts) when is_list(opts) do
    maybe_silence_mcp_server_logs()
    assert_not_prod!(opts)
    :ok = Server.init_tools()

    %{
      allow_remote_access: Keyword.get(opts, :allow_remote_access, false)
    }
  end

  def init(%{} = opts) do
    maybe_silence_mcp_server_logs()
    Map.merge(%{allow_remote_access: false}, opts)
  end

  defp maybe_silence_mcp_server_logs do
    if Application.get_env(:corex, :debug) do
      :ok
    else
      Logger.put_module_level(Corex.MCP.Server, :none)
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

  @impl true
  def call(%Plug.Conn{path_info: ["corex" | rest]} = conn, config) do
    conn
    |> validate!()
    |> Plug.Conn.put_private(:corex_mcp_config, config)
    |> Plug.forward(rest, Corex.MCP.Router, [])
    |> Plug.Conn.halt()
  end

  def call(conn, _opts) do
    validate!(conn)
  end

  defp validate!(conn) do
    if live_reload_enabled?(conn) or request_body_parsed?(conn) do
      raise "plug Corex.MCP is runnning too late, after the request body has been parsed. " <>
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
