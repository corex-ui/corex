defmodule E2e.Form.SliderForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :volume, :float
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
      greater_than: 90.0,
      message: "must be over 90"
    )
  end
end
