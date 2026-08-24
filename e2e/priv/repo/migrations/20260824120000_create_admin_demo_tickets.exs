defmodule E2e.Repo.Migrations.CreateAdminDemoTickets do
  use Ecto.Migration

  def change do
    create table(:admin_demo_sessions, primary_key: false) do
      add :demo_id, :string, primary_key: true
      add :last_seen_at, :utc_datetime, null: false
    end

    create table(:admin_demo_tickets) do
      add :demo_id, :string, null: false
      add :title, :string, null: false
      add :email, :string, null: false
      add :status, :string, null: false, default: "open"
      add :priority, :integer, null: false, default: 1
      add :body, :text
      add :secret, :string

      timestamps(type: :utc_datetime)
    end

    create index(:admin_demo_tickets, [:demo_id])
  end
end
