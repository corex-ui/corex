defmodule E2e.Repo.Migrations.AddTagsToUsersAndAdmins do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :tags, {:array, :string}, default: ["alpha", "beta"], null: false
    end

    alter table(:admins) do
      add :tags, {:array, :string}, default: ["alpha", "beta"], null: false
    end
  end
end
