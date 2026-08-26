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
    names = Enum.map(spec.filters, &{&1.name, &1.type})

    assert {:status, :multi_select} in names
    assert {:priority, :number_range} in names
    assert {:inserted_at, :date_range} in names
  end

  test "applies index/show defaults and resource options" do
    spec = TicketResource.__corex_admin_resource__()
    fields = Map.new(spec.fields, &{&1.name, &1})

    refute fields[:body].index
    assert fields[:title].index
    assert spec.default_sort == {:inserted_at, :desc}
    assert spec.title_field == :title
    assert spec.selectable
    assert spec.page_size_options == [10, 25, 50, 100]
  end

  test "registers embeds_many child fields" do
    spec = TicketResource.__corex_admin_resource__()
    fields = Map.new(spec.fields, &{&1.name, &1})
    embed = fields[:social_links]

    assert embed.type == :embeds_many
    refute embed.index
    assert embed.writable
    assert Enum.map(embed.fields, & &1.name) == [:label, :url, :preferred]
    assert hd(embed.fields).type == :text
  end
end
