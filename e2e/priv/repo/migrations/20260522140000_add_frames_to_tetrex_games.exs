defmodule E2e.Repo.Migrations.AddFramesToTetrexGames do
  use Ecto.Migration

  def change do
    alter table(:tetrex_games) do
      add :frames, {:array, :map}, default: []
    end
  end
end
