defmodule E2e.Form.AngleSliderForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :angle, :float, default: 0.0
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:angle])
    |> validate_required([:angle])
  end
end
