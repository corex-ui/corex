defmodule E2e.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      E2eWeb.Telemetry,
      E2e.Repo,
      {DNSCluster, query: Application.get_env(:e2e, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: E2e.PubSub},
      # Start a worker by calling: E2e.Worker.start_link(arg)
      # {E2e.Worker, arg},
      # Start to serve requests, typically the last entry
      E2eWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: E2e.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    E2eWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
