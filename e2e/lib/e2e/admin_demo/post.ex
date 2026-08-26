defmodule E2e.AdminDemo.Post do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "admin_demo_posts" do
    field(:demo_id, :string)
    field(:title, :string)
    field(:slug, :string)
    field(:status, :string, default: "draft")
    field(:author, :string)
    field(:excerpt, :string)
    field(:body, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:demo_id, :title, :slug, :status, :author, :excerpt, :body])
    |> validate_required([:demo_id, :title, :slug, :status, :author])
    |> validate_inclusion(:status, ~W(draft published))
    |> validate_format(:slug, ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/)
    |> validate_format(:author, ~r/@/)
    |> unique_constraint([:demo_id, :slug])
  end
end
