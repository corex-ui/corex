defmodule E2e.Repo.Migrations.AddAdminDemoRelations do
  use Ecto.Migration

  def change do
    create table(:admin_demo_authors) do
      add(:demo_id, :string, null: false)
      add(:name, :string, null: false)
      add(:email, :string, null: false)
      add(:role, :string, null: false, default: "writer")
      add(:bio, :text)
      add(:active, :boolean, null: false, default: true)

      timestamps(type: :utc_datetime)
    end

    create(index(:admin_demo_authors, [:demo_id]))
    create(unique_index(:admin_demo_authors, [:demo_id, :email]))

    alter table(:admin_demo_posts) do
      add(:author_id, references(:admin_demo_authors, on_delete: :nilify_all))
      add(:published_at, :utc_datetime)
      add(:featured, :boolean, null: false, default: false)
      add(:tags, {:array, :string}, null: false, default: [])
      remove(:author, :string)
    end

    alter table(:admin_demo_tickets) do
      add(:assignee_id, references(:admin_demo_authors, on_delete: :nilify_all))
      add(:due_on, :date)
    end

    create(index(:admin_demo_posts, [:author_id]))
    create(index(:admin_demo_tickets, [:assignee_id]))
  end
end
