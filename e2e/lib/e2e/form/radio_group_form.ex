defmodule E2e.Form.RadioGroupForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :choice, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:choice])
    |> validate_required(:choice)
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:choice])
    |> validate_required([:choice], message: "can't be blank")
  end
end
