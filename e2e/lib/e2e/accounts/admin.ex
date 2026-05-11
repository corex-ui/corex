defmodule E2e.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "admins" do
    field :name, :string
    field :country, Ecto.Enum, values: [:fra, :deu, :bel]
    field :signature, :string
    field :birth_date, :date
    field :terms, :boolean, default: false
    field :level, :integer, default: 1

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:name, :signature, :country, :birth_date, :terms, :level])
    |> validate_required([:name, :signature, :country, :birth_date, :terms, :level])
    |> validate_acceptance(:terms)
    |> validate_inclusion(:country, Ecto.Enum.values(E2e.Accounts.Admin, :country))
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
  end
end
