defmodule E2e.AdminDemo.Session do
  @moduledoc false
  use Ecto.Schema

  @primary_key {:demo_id, :string, autogenerate: false}
  schema "admin_demo_sessions" do
    field(:last_seen_at, :utc_datetime)
  end
end
