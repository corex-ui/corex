defmodule E2e.Form.DateInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :born_on, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:born_on])
    |> validate_required([:born_on], message: "can't be blank")
  end
end
