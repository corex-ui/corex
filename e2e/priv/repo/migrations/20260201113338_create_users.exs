defmodule E2e.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :country, :string
      add :terms, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
