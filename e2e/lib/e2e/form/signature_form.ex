defmodule E2e.Form.SignatureForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :signature, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:signature])
  end
end
