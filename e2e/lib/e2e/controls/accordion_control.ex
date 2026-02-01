defmodule E2e.AccordionControl do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :disabled, :boolean, default: false
    field :disabled_lorem, :boolean, default: false
    field :rtl, :boolean, default: false
  end

  def changeset(accordion_control, attrs \\ %{}) do
    accordion_control
    |> cast(attrs, [:disabled, :disabled_lorem, :rtl])
  end
end
