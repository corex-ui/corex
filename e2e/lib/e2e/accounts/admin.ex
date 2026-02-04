defmodule E2e.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field :name, :string
    field :country, :string
    field :terms, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:name, :country, :terms])
    |> validate_required([:name, :country, :terms])
    |> validate_acceptance(:terms)
  end
end
