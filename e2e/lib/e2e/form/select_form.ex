defmodule E2e.Form.SelectForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :country, :string
  end

  def changeset(select_form, attrs \\ %{}) do
    select_form
    |> cast(attrs, [:country])
    |> validate_required([:country])
  end
end
