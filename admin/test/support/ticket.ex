defmodule CorexAdmin.Test.Ticket do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias CorexAdmin.Test.SocialLink

  schema "tickets" do
    field(:demo_id, :string)
    field(:title, :string)
    field(:email, :string)
    field(:status, :string)
    field(:priority, :integer)
    field(:body, :string)
    field(:password, :string, redact: true)
    field(:secret, :string, redact: true)

    embeds_many(:social_links, SocialLink, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:demo_id, :title, :email, :status, :priority, :body, :password, :secret])
    |> validate_required([:title, :email, :status])
    |> validate_inclusion(:status, ~w(open done))
    |> cast_embed(:social_links,
      with: &SocialLink.changeset/2,
      sort_param: :social_links_sort,
      drop_param: :social_links_drop
    )
  end
end
