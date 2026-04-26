defmodule E2e.Form.Terms do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:terms, :boolean, default: false)
  end

  def changeset(terms, attrs \\ %{}) do
    terms
    |> cast(attrs, [:terms])
    |> validate_required([:terms])
    |> validate_acceptance(:terms)
  end

  def changeset_validate(terms, attrs \\ %{}) do
    terms
    |> cast(attrs, [:terms])
    |> validate_required([:terms], message: "can't be blank")
    |> validate_acceptance(:terms, message: "must be accepted to continue")
  end
end
