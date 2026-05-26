defmodule E2e.Repo.Migrations.WidenSignatureOnUsersAndAdmins do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :signature, {:array, :text}, default: []
    end

    alter table(:admins) do
      modify :signature, {:array, :text}, default: []
    end
  end
end
