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
end
