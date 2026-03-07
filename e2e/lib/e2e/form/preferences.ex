defmodule E2e.Form.Preferences do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :terms, :boolean, default: false
    field :notifications, :boolean, default: false
  end

  def changeset(preferences, attrs \\ %{}) do
    preferences
    |> cast(attrs, [:terms, :notifications])
    |> validate_required([:terms, :notifications])
    |> validate_acceptance(:terms)
  end
end
