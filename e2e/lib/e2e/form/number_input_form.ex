defmodule E2e.Form.NumberInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :value, :float
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> validate_number(:value,
      greater_than_or_equal_to: 1.0,
      less_than_or_equal_to: 9999.0
    )
  end

  def format_for_toast(%__MODULE__{value: v}) when is_float(v) and v == trunc(v) do
    "value=#{trunc(v)}"
  end

  def format_for_toast(%__MODULE__{value: v}), do: "value=#{v}"
end
