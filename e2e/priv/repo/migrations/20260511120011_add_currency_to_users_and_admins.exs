defmodule E2e.Repo.Migrations.AddCurrencyToUsersAndAdmins do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :currency, :string, default: "eur", null: false
    end

    alter table(:admins) do
      add :currency, :string, default: "eur", null: false
    end
  end
end
