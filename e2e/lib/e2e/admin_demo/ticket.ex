defmodule E2e.AdminDemo.Ticket do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias E2e.AdminDemo.{Author, SocialLink}

  @statuses ~w(open pending done)

  schema "admin_demo_tickets" do
    field(:demo_id, :string)
    field(:title, :string)
    field(:email, :string)
    field(:status, :string, default: "open")
    field(:priority, :integer, default: 1)
    field(:body, :string)
    field(:secret, :string, redact: true)
    field(:due_on, :date)

    belongs_to(:assignee, Author)

    embeds_many(:social_links, SocialLink, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  def statuses, do: @statuses

  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [
      :demo_id,
      :title,
      :email,
      :status,
      :priority,
      :body,
      :secret,
      :due_on,
      :assignee_id
    ])
    |> validate_required([:demo_id, :title, :email, :status, :priority])
    |> validate_inclusion(:status, @statuses)
    |> validate_number(:priority, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_format(:email, ~r/^[^@\s]+@[^@\s]+$/, message: "must be an email address")
    |> assoc_constraint(:assignee)
    |> cast_embed(:social_links,
      with: &SocialLink.changeset/2,
      sort_param: :social_links_sort,
      drop_param: :social_links_drop
    )
    |> validate_single_preferred_link()
  end

  # The admin already clears extra flags in the submitted params, but the rule
  # belongs to the schema: an import or a second tab must not be able to save
  # two preferred links either.
  defp validate_single_preferred_link(changeset) do
    links = get_field(changeset, :social_links) || []

    if Enum.count(links, & &1.preferred) > 1 do
      add_error(changeset, :social_links, "only one link can be preferred")
    else
      changeset
    end
  end
end
