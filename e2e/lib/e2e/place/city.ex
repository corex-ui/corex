defmodule E2e.Place.City do
  use Ecto.Schema
  import Ecto.Changeset
  alias E2e.Place.Airport

  @primary_key {:id, :string, autogenerate: false}

  schema "cities" do
    field :name, :string
    field :iata_code, :string
    field :iata_country_code, :string

    embeds_many :airports, Airport, on_replace: :delete
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:id, :iata_code, :iata_country_code, :name])
    |> validate_required([:iata_code, :iata_country_code, :name])
    |> cast_embed(:airports)
  end
end
