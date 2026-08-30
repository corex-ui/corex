defmodule E2e.Repo.Migrations.AddSocialLinksToAdminDemoTickets do
  use Ecto.Migration

  def change do
    alter table(:admin_demo_tickets) do
      add :social_links, {:array, :map}, default: [], null: false
    end
  end
end
