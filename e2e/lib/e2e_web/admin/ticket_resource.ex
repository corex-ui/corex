defmodule E2eWeb.Admin.TicketResource do
  @moduledoc false

  use CorexAdmin.Resource,
    context: E2e.AdminDemo,
    schema: E2e.AdminDemo.Ticket,
    slug: "tickets",
    group: "Demo",
    label: "Tickets"

  scope(:current_scope)

  actions do
    list(:list_tickets)
    get(:get_ticket!)
    create :create_ticket
    update(:update_ticket)
    delete(:delete_ticket)
    change_create(:change_ticket)
    change_update(:change_ticket)
  end

  fields do
    field :id, :id
    field :title, :text, searchable: true, sortable: true
    field :email, :email, searchable: true, sortable: true
    field :status, :select, options: ~W(open done), filterable: true
    field :priority, :number, sortable: true
    field :body, :textarea
    field :secret, :text, redact: true, readable: false
    field :inserted_at, :datetime
  end

  filters do
    filter(:status, :select, options: ~W(open done))
  end
end
