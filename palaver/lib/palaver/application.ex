defmodule Palaver.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Palaver.Registry},
      {DynamicSupervisor, name: Palaver.SessionSupervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Palaver.Supervisor)
  end
end
