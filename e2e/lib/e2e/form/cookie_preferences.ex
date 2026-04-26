defmodule E2e.Form.CookiePreferences do
  use Ecto.Schema
  import Ecto.Changeset

  @frequencies ~w(daily weekly monthly never)

  embedded_schema do
    field(:analytics, :boolean, default: false)
    field(:marketing, :boolean, default: false)
    field(:frequency, :string, default: "weekly")
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, [:analytics, :marketing, :frequency])
    |> validate_required([:frequency])
    |> validate_inclusion(:frequency, @frequencies)
  end

  def frequencies, do: @frequencies
end
