defmodule CorexAdmin.Test.TicketResource do
  @moduledoc false

  use CorexAdmin.Resource,
    context: CorexAdmin.Test.Tickets,
    schema: CorexAdmin.Test.Ticket,
    slug: "tickets",
    group: "Support",
    label: "Tickets",
    page_size: 25,
    page_size_options: [10, 25, 50, 100],
    default_sort: {:inserted_at, :desc},
    title_field: :title,
    selectable: true,
    history: CorexAdmin.Test.History

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
    field(:status, :select, options: ~w(open done))
    field(:priority, :number, sortable: true)
    field(:body, :textarea)
    field(:password, :password)
    field(:secret, :text, redact: true, readable: false)
    field(:inserted_at, :datetime, sortable: true)

    field :social_links, :embeds_many, schema: CorexAdmin.Test.SocialLink, index: false do
      field(:label, :text)
      field(:url, :url)
      field(:preferred, :boolean)
    end
  end

  filters do
    filter(:status, :multi_select, options: ~w(open done), pin: true, operators: [:in, :not_in])
    filter(:priority, :number_range, min: 1, max: 5)
    filter(:inserted_at, :date_range)
    filter(:email, :text, pin: false)
    filter(:body, :presence, pin: false)
    filter(:id, :id, pin: false)
    filter(:created, :relative_date, field: :inserted_at, pin: false)
  end

  def canned_filters do
    [{"Open only", %{"filters" => %{"status" => ["open"]}}}]
  end
end
