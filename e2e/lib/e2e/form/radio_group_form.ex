defmodule E2e.Form.RadioGroupForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :choice, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:choice])
  end
end
