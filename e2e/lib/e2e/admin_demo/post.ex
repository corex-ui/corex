defmodule E2e.AdminDemo.Post do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias E2e.AdminDemo.Author

  @statuses ~W(draft scheduled published archived)

  schema "admin_demo_posts" do
    field(:demo_id, :string)
    field(:title, :string)
    field(:slug, :string)
    field(:status, :string, default: "draft")
    field(:excerpt, :string)
    field(:body, :string)
    field(:published_at, :utc_datetime)
    field(:featured, :boolean, default: false)
    field(:tags, {:array, :string}, default: [])

    belongs_to(:author, Author)

    timestamps(type: :utc_datetime)
  end

  def statuses, do: @statuses

  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :demo_id,
      :title,
      :slug,
      :status,
      :excerpt,
      :body,
      :published_at,
      :featured,
      :tags,
      :author_id
    ])
    |> validate_required([:demo_id, :title, :slug, :status])
    |> validate_inclusion(:status, @statuses)
    |> validate_format(:slug, ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/,
      message: "must be lowercase words separated by hyphens"
    )
    |> require_publish_date()
    |> assoc_constraint(:author)
    |> unique_constraint([:demo_id, :slug])
  end

  # A scheduled or published post without a date would never sort or filter
  # correctly, so the state and the timestamp are validated together.
  defp require_publish_date(changeset) do
    case get_field(changeset, :status) do
      status when status in ~W(scheduled published) ->
        validate_required(changeset, [:published_at])

      _ ->
        changeset
    end
  end
end
