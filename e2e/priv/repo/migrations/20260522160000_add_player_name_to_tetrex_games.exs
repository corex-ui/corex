defmodule E2e.Repo.Migrations.AddPlayerNameToTetrexGames do
  use Ecto.Migration

  def change do
    alter table(:tetrex_games) do
      add :player_name, :string
    end
  end
end
