defmodule E2e.AdminDemo.Ticket do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias E2e.AdminDemo.SocialLink

  schema "admin_demo_tickets" do
    field(:demo_id, :string)
    field(:title, :string)
    field(:email, :string)
    field(:status, :string, default: "open")
    field(:priority, :integer, default: 1)
    field(:body, :string)
    field(:secret, :string, redact: true)

    embeds_many(:social_links, SocialLink, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:demo_id, :title, :email, :status, :priority, :body, :secret])
    |> validate_required([:demo_id, :title, :email, :status, :priority])
    |> validate_inclusion(:status, ~W(open done))
    |> validate_number(:priority, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_format(:email, ~r/@/)
    |> cast_embed(:social_links,
      with: &SocialLink.changeset/2,
      sort_param: :social_links_sort,
      drop_param: :social_links_drop
    )
  end
end
