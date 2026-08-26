defmodule E2eWeb.Admin.TicketResource do
  @moduledoc false

  use CorexAdmin.Resource,
    context: E2e.AdminDemo,
    schema: E2e.AdminDemo.Ticket,
    slug: "tickets",
    group: "Demo",
    label: "Tickets",
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

  fields do
    field(:id, :id)
    field(:title, :text, searchable: true, sortable: true)
    field(:email, :email, searchable: true, sortable: true)
    field(:status, :select, options: ~W(open done))
    field(:priority, :number, sortable: true)
    field(:body, :textarea)
    field(:secret, :text, redact: true, readable: false)
    field(:inserted_at, :datetime, sortable: true)

    field :social_links, :embeds_many, schema: E2e.AdminDemo.SocialLink, index: false do
      field(:label, :text)
      field(:url, :url)
      field(:preferred, :boolean)
    end
  end

  filters do
    filter(:status, :multi_select, options: ~W(open done))
    filter(:priority, :number_range)
    filter(:inserted_at, :date_range)
  end
end
