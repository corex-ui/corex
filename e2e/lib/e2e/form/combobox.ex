defmodule E2e.Form.Combobox do
  use Ecto.Schema
  import Ecto.Changeset
  alias E2e.Form.Combobox

  embedded_schema do
    field :name, :string
    field :airport, :string
  end

  @doc false
  def change_combobox(%Combobox{} = combobox, attrs \\ %{}) do
    changeset(combobox, attrs)
  end

  @doc false
  def changeset(%Combobox{} = combobox, attrs) do
    combobox
    |> cast(attrs, [:name, :airport])
    |> validate_required([:name, :airport])
  end
end
