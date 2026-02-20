defmodule E2e.Place.Airport do
  use Ecto.Schema
  import Ecto.Changeset
  alias E2e.Place.City

  @primary_key {:id, :string, autogenerate: false}

  schema "airports" do
    field :name, :string
    field :time_zone, :string
    field :iata_code, :string
    field :city_name, :string
    field :iata_city_code, :string
    field :iata_country_code, :string
    field :icao_code, :string
    field :latitude, :float
    field :longitude, :float

    embeds_one :city, City, on_replace: :delete
  end

  @doc false
  def changeset(airport, attrs) do
    airport
    |> cast(attrs, [
      :id,
      :iata_code,
      :name,
      :city_name,
      :iata_city_code,
      :iata_country_code,
      :icao_code,
      :latitude,
      :longitude,
      :time_zone
    ])
    |> validate_required([
      :iata_code,
      :name,
      :iata_city_code,
      :iata_country_code,
      :latitude,
      :longitude,
      :time_zone
    ])
  end
end
