defmodule E2e.Repo.Migrations.HashUserAndAdminPasswords do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :hashed_password, :string
    end

    alter table(:admins) do
      add :hashed_password, :string
    end

    flush()
    hash_existing("users")
    hash_existing("admins")

    alter table(:users) do
      remove :password
    end

    alter table(:admins) do
      remove :password
    end
  end

  def down do
    alter table(:users) do
      add :password, :string
    end

    alter table(:admins) do
      add :password, :string
    end

    flush()

    alter table(:users) do
      remove :hashed_password
    end

    alter table(:admins) do
      remove :hashed_password
    end
  end

  defp hash_existing(table) do
    repo().query!("SELECT id, password FROM #{table}", [], log: false).rows
    |> Enum.each(fn [id, password] ->
      hash =
        if is_binary(password) and password != "" do
          Bcrypt.hash_pwd_salt(password)
        else
          Bcrypt.hash_pwd_salt("password1")
        end

      repo().query!("UPDATE #{table} SET hashed_password = $1 WHERE id = $2", [hash, id],
        log: false
      )
    end)
  end
end
