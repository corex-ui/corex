defmodule E2e.Form.SliderRangeForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :volume, {:array, :float}
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
    |> validate_length(:volume, is: 2, message: "must have two values")
    |> validate_high_over_90()
  end

  defp validate_high_over_90(changeset) do
    case get_field(changeset, :volume) do
      [_, high] when is_number(high) and high > 90 ->
        changeset

      [_, _high] ->
        add_error(changeset, :volume, "must be over 90")

      _ ->
        changeset
    end
  end
end
