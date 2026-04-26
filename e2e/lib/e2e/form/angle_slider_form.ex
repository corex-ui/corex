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

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:angle])
    |> validate_required([:angle])
    |> validate_number(:angle,
      greater_than_or_equal_to: 0.0,
      less_than_or_equal_to: 90.0,
      message: "must be between 0 and 90"
    )
  end
end
