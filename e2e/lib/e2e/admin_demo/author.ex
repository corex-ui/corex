defmodule E2e.AdminDemo.Author do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias E2e.AdminDemo.{Post, Ticket}

  @roles ~w(editor writer reviewer)

  schema "admin_demo_authors" do
    field(:demo_id, :string)
    field(:name, :string)
    field(:email, :string)
    field(:role, :string, default: "writer")
    field(:bio, :string)
    field(:active, :boolean, default: true)

    has_many(:posts, Post, foreign_key: :author_id)
    has_many(:assigned_tickets, Ticket, foreign_key: :assignee_id)

    timestamps(type: :utc_datetime)
  end

  def roles, do: @roles

  def changeset(author, attrs) do
    author
    |> cast(attrs, [:demo_id, :name, :email, :role, :bio, :active])
    |> validate_required([:demo_id, :name, :email, :role])
    |> validate_inclusion(:role, @roles)
    |> validate_format(:email, ~r/^[^@\s]+@[^@\s]+$/, message: "must be an email address")
    |> unique_constraint([:demo_id, :email])
  end
end
