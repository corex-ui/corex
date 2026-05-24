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

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:pin])
    |> validate_required([:pin], message: "can't be blank")
    |> validate_length(:pin, is: 4, message: "must be 4 characters")
  end
end
