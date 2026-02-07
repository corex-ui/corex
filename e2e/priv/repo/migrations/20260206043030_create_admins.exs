defmodule E2e.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string
      add :country, :string
      add :birth_date, :date
      add :terms, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
