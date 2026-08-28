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
    assert {:email, :text} in names
    assert {:body, :presence} in names
    assert {:id, :id} in names
    assert {:created, :relative_date} in names

    pins = Map.new(spec.filters, &{&1.name, &1.pin})
    assert pins[:status]
    refute pins[:email]
    refute pins[:id]

    status = Enum.find(spec.filters, &(&1.name == :status))
    assert CorexAdmin.Resource.Filter.operators(status) == [:in]
    refute :not_in in CorexAdmin.Resource.Filter.operators(status)
    assert CorexAdmin.Resource.Filter.relative_bounds("today") != :error
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
    assert spec.singular == "Ticket"
    assert spec.history == CorexAdmin.Test.History
    assert CorexAdmin.Action.Export in spec.collection_actions
    assert CorexAdmin.Action.Delete in spec.record_actions
  end

  test "injects title/1 and query/2" do
    spec = TicketResource.__corex_admin_resource__()
    record = %{id: 7, title: "Hello"}

    assert TicketResource.title(record) == "Hello"
    assert function_exported?(TicketResource, :query, 2)
    assert function_exported?(TicketResource, :canned_filters, 0)

    assert [{"Open only", %{"filters" => %{"status" => ["open"]}}}] =
             TicketResource.canned_filters()

    assert spec.live == %{}
  end

  test "accepts a host field module as the type" do
    spec =
      CorexAdmin.Resource.build_spec(
        FakeCustom,
        [
          context: CorexAdmin.Test.Tickets,
          schema: CorexAdmin.Test.Ticket,
          slug: "custom",
          label: "Custom"
        ],
        [{:title, CorexAdmin.Test.Fields.Uppercase, []}],
        [],
        [
          list: :list_tickets,
          get: :get_ticket!,
          create: :create_ticket,
          update: :update_ticket,
          delete: :delete_ticket,
          change_create: :change_ticket,
          change_update: :change_ticket
        ],
        nil
      )

    [field] = spec.fields
    assert field.type == :custom
    assert field.mod == CorexAdmin.Test.Fields.Uppercase
    assert CorexAdmin.Field.module(field) == CorexAdmin.Test.Fields.Uppercase
  end

  test "builds form and show sections" do
    spec =
      CorexAdmin.Resource.build_spec(
        FakeSections,
        [
          context: CorexAdmin.Test.Tickets,
          schema: CorexAdmin.Test.Ticket,
          slug: "sectioned"
        ],
        [{:title, :text, []}, {:email, :email, []}],
        [],
        [
          list: :list_tickets,
          get: :get_ticket!,
          create: :create_ticket,
          update: :update_ticket,
          delete: :delete_ticket,
          change_create: :change_ticket,
          change_update: :change_ticket
        ],
        nil,
        %{
          form_sections: [{"Details", [:title]}, {"Contact", [:email]}],
          show_sections: [{"Overview", [:title, :email]}]
        }
      )

    assert Enum.map(spec.form_sections, & &1.label) == ["Details", "Contact"]
    assert hd(spec.form_sections).fields == [:title]
    assert Enum.map(spec.show_sections, & &1.label) == ["Overview"]
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
