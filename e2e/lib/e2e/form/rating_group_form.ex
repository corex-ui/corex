defmodule E2e.Form.RatingGroupForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :score, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:score])
    |> validate_required([:score], message: "can't be blank")
  end
end
