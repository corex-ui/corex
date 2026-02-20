defmodule E2e.Repo.Migrations.CreateAirports do
  use Ecto.Migration

  def change do
    create table(:airports, primary_key: false) do
      add :id, :string, primary_key: true
      add :iata_code, :string
      add :name, :string
      add :city_name, :string
      add :iata_city_code, :string
      add :iata_country_code, :string
      add :icao_code, :string
      add :latitude, :float
      add :longitude, :float
      add :time_zone, :string
      add :city, :map
    end
  end
end
