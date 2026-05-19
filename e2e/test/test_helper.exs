ExUnit.start(max_cases: 1, timeout: 120_000)

case Application.ensure_all_started(:wallaby) do
  {:ok, _} -> :ok
  {:error, reason} -> raise "failed to start :wallaby: #{inspect(reason)}"
end

Ecto.Adapters.SQL.Sandbox.mode(E2e.Repo, :manual)
Application.put_env(:wallaby, :base_url, E2eWeb.Endpoint.url())
