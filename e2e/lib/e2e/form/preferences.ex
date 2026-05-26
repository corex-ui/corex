defmodule E2e.Form.Preferences do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :notifications, :boolean, default: false
  end

  def changeset(preferences, attrs \\ %{}) do
    preferences
    |> cast(attrs, [:notifications])
    |> validate_acceptance(:notifications)
  end

  def changeset_validate(preferences, attrs \\ %{}) do
    preferences
    |> cast(attrs, [:notifications])
    |> validate_acceptance(:notifications, message: "must be accepted to continue")
  end
end
