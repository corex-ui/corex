defmodule E2e.Form.PinInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :pin, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:pin])
  end
end
