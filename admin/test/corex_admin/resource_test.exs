defmodule CorexAdmin.ResourceTest do
  use ExUnit.Case, async: true

  alias CorexAdmin.Test.TicketResource

  test "builds a spec from the resource DSL" do
    spec = TicketResource.__corex_admin_resource__()

    assert spec.slug == "tickets"
    assert spec.group == "Support"
    assert spec.context == CorexAdmin.Test.Tickets
    assert spec.scope == :current_scope
    assert spec.actions.list == :list_tickets
    assert spec.actions.change_create == :change_ticket
    assert spec.actions.change_update == :change_ticket
  end

  test "applies secure field defaults" do
    spec = TicketResource.__corex_admin_resource__()
    fields = Map.new(spec.fields, &{&1.name, &1})

    refute fields[:id].writable
    refute fields[:inserted_at].writable
    refute fields[:password].readable
    assert fields[:password].writable
    assert fields[:password].redact
    assert fields[:secret].redact
    refute fields[:secret].readable
    assert fields[:title].searchable
    assert fields[:title].sortable
    refute fields[:body].searchable
  end

  test "registers filters" do
    spec = TicketResource.__corex_admin_resource__()
    assert [%{name: :status, type: :select}] = spec.filters
  end
end
