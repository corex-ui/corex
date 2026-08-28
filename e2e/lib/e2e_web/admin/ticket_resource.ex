defmodule E2eWeb.Admin.TicketResource do
  @moduledoc """
  Support queue.

  Shows the parts of the DSL a real staff tool needs: a relation picker fed by
  the context, a date filter, a slider whose bounds come from the data, a bulk
  action with a form, and a nested list with a one-of flag.
  """

  use CorexAdmin.Resource,
    context: E2e.AdminDemo,
    schema: E2e.AdminDemo.Ticket,
    slug: "tickets",
    group: "Support",
    label: "Tickets",
    singular: "Ticket",
    page_size: 25,
    page_size_options: [10, 25, 50, 100],
    default_sort: {:inserted_at, :desc},
    title_field: :title,
    selectable: true

  scope(:current_scope)

  actions do
    list(:list_tickets)
    get(:get_ticket!)
    create(:create_ticket)
    update(:update_ticket)
    delete(:delete_ticket)
    change_create(:change_ticket)
    change_update(:change_ticket)
  end

  bulk_actions do
    action(CorexAdmin.Action.BulkDelete)
    action(CorexAdmin.Action.Export)
    action(E2eWeb.Admin.Actions.SetTicketStatus)
  end

  fields do
    field(:id, :id)
    field(:title, :text, searchable: true, sortable: true)
    field(:email, :email, searchable: true, sortable: true)
    field(:status, :select, options: ~w(open pending done), render: {E2eWeb.Admin.Cells, :status})
    field(:priority, :number, sortable: true)
    field(:due_on, :date, sortable: true)

    field(:assignee, :belongs_to,
      label: "Assignee",
      relation: [
        context: E2e.AdminDemo,
        list: :list_authors,
        label: :name,
        owner_key: :assignee_id,
        search: true
      ]
    )

    field(:body, :textarea)
    field(:secret, :text, redact: true, readable: false)
    field(:inserted_at, :datetime, sortable: true)

    field :social_links, :embeds_many, schema: E2e.AdminDemo.SocialLink, index: false do
      field(:label, :text)
      field(:url, :url)
      field(:preferred, :boolean, exclusive: true)
    end
  end

  form do
    section("Request", [:title, :email, :status, :priority, :due_on, :assignee])
    section("Details", [:body, :social_links])
  end

  filters do
    filter(:status, :multi_select, options: ~w(open pending done), pin: true)
    filter(:priority, :number_range, pin: true)
    filter(:due_on, :date_range, label: "Due", pin: true)
    filter(:assignee_name, :text, label: "Assignee", path: [:assignee, :name], pin: false)
    filter(:email, :text, pin: false)
    filter(:body, :presence, label: "Description", pin: false)
    filter(:created, :relative_date, field: :inserted_at, pin: false)
    filter(:id, :id, pin: false)
  end

  def canned_filters do
    [
      {"Open queue", %{"filters" => %{"status" => ["open"]}}},
      {"Needs a reply", %{"filters" => %{"status" => ["pending"]}}},
      {"Closed", %{"filters" => %{"status" => ["done"]}}}
    ]
  end

  def title(ticket), do: "##{ticket.id} #{ticket.title}"

  def filter_options(scope, :status), do: E2e.AdminDemo.ticket_statuses(scope)
  def filter_options(_scope, _name), do: nil

  def filter_bounds(scope, :priority), do: E2e.AdminDemo.ticket_priority_bounds(scope)
  def filter_bounds(_scope, _name), do: nil

  def metrics(scope, _list_opts) do
    counts = E2e.AdminDemo.ticket_counts(scope)
    total = counts |> Map.values() |> Enum.sum()

    [
      %{label: "All tickets", value: total},
      %{label: "Open", value: Map.get(counts, "open", 0), hint: "waiting on us"},
      %{label: "Pending", value: Map.get(counts, "pending", 0), hint: "waiting on customer"},
      %{label: "Done", value: Map.get(counts, "done", 0)}
    ]
  end
end
