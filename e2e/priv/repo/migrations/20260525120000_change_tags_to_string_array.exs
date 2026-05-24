defmodule E2e.Repo.Migrations.ChangeTagsToStringArray do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE users ALTER COLUMN tags DROP DEFAULT")
    execute("ALTER TABLE admins ALTER COLUMN tags DROP DEFAULT")

    execute("""
    ALTER TABLE users
    ALTER COLUMN tags TYPE varchar(255)[]
    USING string_to_array(tags, ',')::varchar(255)[]
    """)

    execute("""
    ALTER TABLE admins
    ALTER COLUMN tags TYPE varchar(255)[]
    USING string_to_array(tags, ',')::varchar(255)[]
    """)

    execute("ALTER TABLE users ALTER COLUMN tags SET DEFAULT '{alpha,beta}'")
    execute("ALTER TABLE admins ALTER COLUMN tags SET DEFAULT '{alpha,beta}'")
  end

  def down do
    execute("ALTER TABLE users ALTER COLUMN tags DROP DEFAULT")
    execute("ALTER TABLE admins ALTER COLUMN tags DROP DEFAULT")

    execute("""
    ALTER TABLE users
    ALTER COLUMN tags TYPE varchar(255)
    USING array_to_string(tags, ',')
    """)

    execute("""
    ALTER TABLE admins
    ALTER COLUMN tags TYPE varchar(255)
    USING array_to_string(tags, ',')
    """)

    execute("ALTER TABLE users ALTER COLUMN tags SET DEFAULT 'alpha,beta'")
    execute("ALTER TABLE admins ALTER COLUMN tags SET DEFAULT 'alpha,beta'")
  end
end
