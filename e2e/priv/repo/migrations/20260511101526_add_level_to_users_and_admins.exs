defmodule E2e.Repo.Migrations.AddLevelToUsersAndAdmins do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :level, :integer, default: 1, null: false
    end

    alter table(:admins) do
      add :level, :integer, default: 1, null: false
    end
  end
end
