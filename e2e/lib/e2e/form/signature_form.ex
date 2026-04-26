defmodule E2e.Form.SignatureForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :signature, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:signature])
    |> validate_required([:signature])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:signature])
    |> validate_required([:signature], message: "can't be blank")
  end
end
