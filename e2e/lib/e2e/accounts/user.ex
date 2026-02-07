defmodule E2e.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :country, :string
    field :birth_date, :date
    field :terms, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :country, :birth_date, :terms])
    |> validate_required([:name, :country, :birth_date, :terms])
    |> validate_acceptance(:terms)
  end
end
