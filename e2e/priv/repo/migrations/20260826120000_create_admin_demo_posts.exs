defmodule E2e.Repo.Migrations.CreateAdminDemoPosts do
  use Ecto.Migration

  def change do
    create table(:admin_demo_posts) do
      add :demo_id, :string, null: false
      add :title, :string, null: false
      add :slug, :string, null: false
      add :status, :string, null: false, default: "draft"
      add :author, :string, null: false
      add :excerpt, :text
      add :body, :text

      timestamps(type: :utc_datetime)
    end

    create index(:admin_demo_posts, [:demo_id])
    create unique_index(:admin_demo_posts, [:demo_id, :slug])
  end
end
