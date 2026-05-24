defmodule E2e.Accounts.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  @currencies ~W(eur usd gbp jpy chf cad aud sek nok sgd)

  def currencies, do: @currencies

  schema "admins" do
    field :name, :string
    field :country, Ecto.Enum, values: [:fra, :deu, :bel]
    field :signature, :string
    field :birth_date, :date
    field :terms, :boolean, default: false
    field :level, :integer, default: 1
    field :currency, :string
    field :tags, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:name, :signature, :country, :birth_date, :terms, :level, :currency, :tags])
    |> validate_required([
      :name,
      :signature,
      :country,
      :birth_date,
      :terms,
      :level,
      :currency,
      :tags
    ])
    |> validate_acceptance(:terms)
    |> validate_inclusion(:country, Ecto.Enum.values(E2e.Accounts.Admin, :country))
    |> validate_number(:level, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)
    |> validate_inclusion(:currency, @currencies)
  end
end
