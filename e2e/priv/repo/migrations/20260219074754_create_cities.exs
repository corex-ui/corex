defmodule E2e.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities, primary_key: false) do
      add :id, :string, primary_key: true
      add :iata_code, :string
      add :iata_country_code, :string
      add :name, :string
      add :airports, :jsonb, default: "[]"
    end
  end
end
