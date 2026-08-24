defmodule E2e.AdminDemo.Ticket do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "admin_demo_tickets" do
    field :demo_id, :string
    field :title, :string
    field :email, :string
    field :status, :string, default: "open"
    field :priority, :integer, default: 1
    field :body, :string
    field :secret, :string, redact: true

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:demo_id, :title, :email, :status, :priority, :body, :secret])
    |> validate_required([:demo_id, :title, :email, :status, :priority])
    |> validate_inclusion(:status, ~W(open done))
    |> validate_number(:priority, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_format(:email, ~r/@/)
  end
end
