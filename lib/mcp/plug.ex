defmodule Corex.MCP do
  @moduledoc false
  @behaviour Plug

  require Logger

  @impl true
  def init(opts) when is_list(opts) do
    maybe_silence_mcp_server_logs()

    build_config(%{
      allow_remote_access: Keyword.get(opts, :allow_remote_access, false),
      verbose_errors: Keyword.get(opts, :verbose_errors, nil)
    })
  end

  def init(%{} = opts) do
    maybe_silence_mcp_server_logs()
    build_config(Map.merge(%{allow_remote_access: false, verbose_errors: nil}, opts))
  end

  defp build_config(config) do
    verbose_errors =
      case Map.get(config, :verbose_errors) do
        nil -> Application.get_env(:corex, :mcp_verbose_errors, false)
        value -> value
      end

    config = Map.put(config, :verbose_errors, verbose_errors)
    maybe_warn_remote_access!(config.allow_remote_access)
    config
  end

  @remote_access_enabled_warning """
  Corex.MCP allow_remote_access is enabled. The MCP endpoint accepts connections from non-loopback addresses. Restrict network access with a firewall or VPN and never enable this in production.
  """

  defp maybe_warn_remote_access!(true), do: Logger.warning(@remote_access_enabled_warning)
  defp maybe_warn_remote_access!(_), do: :ok

  defp maybe_silence_mcp_server_logs do
    if Application.get_env(:corex, :debug) do
      :ok
    else
      Logger.put_module_level(Corex.MCP.Server, :none)
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
    conn
    |> Plug.Conn.register_before_send(fn conn ->
      conn
      |> maybe_rewrite_csp()
      |> Plug.Conn.delete_resp_header("x-frame-options")
    end)
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

  defp maybe_rewrite_csp(conn) do
    case Plug.Conn.get_resp_header(conn, "content-security-policy") do
      [csp | _] ->
        csp = rewrite_csp(csp)
        Plug.Conn.put_resp_header(conn, "content-security-policy", csp)

      _ ->
        conn
    end
  end

  defp rewrite_csp(csp) do
    policy_directives = String.split(csp, ";", trim: true)

    for policy_directive <- policy_directives,
        policy_directive = String.trim(policy_directive),
        not String.starts_with?(policy_directive, "frame-ancestors") do
      rewrite_csp_directive(policy_directive)
    end
    |> Enum.join("; ")
  end

  defp rewrite_csp_directive(policy_directive) do
    case String.split(policy_directive, " ", parts: 2) do
      ["script-src", directives] ->
        script_src_with_unsafe_eval(directives)

      [policy, directives] ->
        "#{policy} #{directives}"

      [leftover] ->
        leftover
    end
  end

  defp script_src_with_unsafe_eval(directives) do
    case :binary.match(directives, "'unsafe-eval'") do
      :nomatch -> "script-src 'unsafe-eval' #{directives}"
      _ -> "script-src #{directives}"
    end
  end
end
