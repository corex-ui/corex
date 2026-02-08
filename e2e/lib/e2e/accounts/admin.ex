defmodule E2e.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field :name, :string
    field :country, Ecto.Enum, values: [:fra, :deu, :bel]
    field :signature, :string
    field :birth_date, :date
    field :terms, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:name, :signature, :country, :birth_date, :terms])
    |> validate_required([:name, :signature, :country, :birth_date, :terms])
    |> validate_acceptance(:terms)
    |> validate_inclusion(:country, Ecto.Enum.values(E2e.Accounts.Admin, :country))
  end
end
