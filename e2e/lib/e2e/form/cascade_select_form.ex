defmodule E2e.Form.CascadeSelectForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :category, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:category])
    |> validate_required([:category], message: "can't be blank")
  end
end
