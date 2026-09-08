defmodule CorexAdmin.ContextTest do
  use ExUnit.Case, async: false

  alias CorexAdmin.{Context, ListOpts, Page}
  alias CorexAdmin.Test.{Store, TicketResource, Tickets}

  setup do
    Store.reset()
    spec = TicketResource.__corex_admin_resource__()
    scope = %{demo_id: "ctx-demo", role: :admin}
    {:ok, spec: spec, scope: scope}
  end

  test "lists through the context", %{spec: spec, scope: scope} do
    {:ok, _} =
      Tickets.create_ticket(scope, %{"title" => "A", "email" => "a@x.test", "status" => "open"})

    {:ok, %Page{entries: entries, total: total}} =
      Context.list(spec, scope, ListOpts.from_params(spec, %{}))

    assert total == 1
    assert hd(entries).title == "A"
  end

  test "does not return other scopes", %{spec: spec, scope: scope} do
    other = %{demo_id: "other", role: :admin}

    {:ok, _} =
      Tickets.create_ticket(other, %{"title" => "Nope", "email" => "n@x.test", "status" => "open"})

    {:ok, %Page{total: total}} = Context.list(spec, scope, ListOpts.from_params(spec, %{}))
    assert total == 0
  end
end
