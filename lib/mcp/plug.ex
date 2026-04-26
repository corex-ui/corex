defmodule Corex.MCP do
  @moduledoc false
  @behaviour Plug

  @impl true
  def init(opts) do
    %{
      allow_remote_access: Keyword.get(opts, :allow_remote_access, false)
    }
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
      case String.split(policy_directive, " ", parts: 2) do
        ["script-src", directives] ->
          case :binary.match(directives, "'unsafe-eval'") do
            :nomatch -> "script-src 'unsafe-eval' #{directives}"
            _ -> "script-src #{directives}"
          end

        [policy, directives] ->
          "#{policy} #{directives}"

        [leftover] ->
          leftover
      end
    end
    |> Enum.join("; ")
  end
end
