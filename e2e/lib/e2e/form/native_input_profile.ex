defmodule E2e.Form.NativeInputProfile do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :email, :string
    field :birth_date, :date
    field :reminder_time, :time
    field :role, :string
    field :agree, :boolean, default: false
  end

  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, [:name, :email, :birth_date, :reminder_time, :role, :agree])
    |> validate_required([:name, :email, :agree])
    |> validate_acceptance(:agree)
  end
end
