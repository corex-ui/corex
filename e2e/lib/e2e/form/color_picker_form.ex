defmodule E2e.Form.ColorPickerForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :color, :string, default: "#3b82f6"
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:color])
    |> validate_required([:color])
  end
end
