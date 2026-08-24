defmodule E2e.Form.SliderForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :volume, :float, default: 0.0
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:volume])
    |> validate_required([:volume])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:volume])
    |> validate_required([:volume])
    |> validate_number(:volume,
      greater_than_or_equal_to: 0.0,
      less_than_or_equal_to: 90.0,
      message: "must be between 0 and 90"
    )
  end
end
