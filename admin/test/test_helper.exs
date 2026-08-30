ExUnit.start()

:ok = CorexAdmin.Test.Store.reset()

{:ok, _} =
  Supervisor.start_link([{Phoenix.PubSub, name: CorexAdmin.Test.PubSub}], strategy: :one_for_one)

{:ok, _} = CorexAdmin.Test.Endpoint.start_link()
