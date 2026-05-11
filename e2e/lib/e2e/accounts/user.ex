defmodule E2e.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :signature, :string
    field :country, :string
    field :birth_date, :date
    field :terms, :boolean, default: false
    field :level, :integer, default: 1

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :signature, :country, :birth_date, :terms, :level])
    |> validate_required([:name, :signature, :country, :birth_date, :terms, :level])
    |> validate_acceptance(:terms)
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
  end
end
