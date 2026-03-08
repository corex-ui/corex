defmodule E2e.Form.DatePickerForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :date, :date
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:date])
  end
end
