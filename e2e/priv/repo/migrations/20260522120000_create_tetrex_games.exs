defmodule E2e.Repo.Migrations.CreateTetrexGames do
  use Ecto.Migration

  def change do
    create table(:tetrex_games, primary_key: false) do
      add :id, :string, primary_key: true
      add :score, :integer, null: false, default: 0
      add :status, :string, null: false
      add :client_state, :map, null: false
      add :ended_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:tetrex_games, [:score])
  end
end
