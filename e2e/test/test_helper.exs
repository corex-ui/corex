ExUnit.start()
{:ok, _} = Application.ensure_all_started(:wallaby)
Ecto.Adapters.SQL.Sandbox.mode(E2e.Repo, :manual)
Application.put_env(:wallaby, :base_url, E2eWeb.Endpoint.url())
