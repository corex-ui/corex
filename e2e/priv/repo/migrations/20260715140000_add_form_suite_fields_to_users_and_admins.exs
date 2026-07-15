defmodule E2e.Repo.Migrations.AddFormSuiteFieldsToUsersAndAdmins do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password, :string
      add :notifications, :boolean, default: false, null: false
      add :role, :string
      add :pin, :string
      add :accent_color, :string
      add :heading_angle, :float
      add :title, :string
      add :avatar, :string
    end

    alter table(:admins) do
      add :password, :string
      add :notifications, :boolean, default: false, null: false
      add :role, :string
      add :pin, :string
      add :accent_color, :string
      add :heading_angle, :float
      add :title, :string
      add :avatar, :string
    end
  end
end
