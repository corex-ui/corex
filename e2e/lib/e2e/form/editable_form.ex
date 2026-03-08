defmodule E2e.Form.EditableForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :text, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:text])
  end
end
