defmodule E2e.Form.Combobox do
  use Ecto.Schema
  import Ecto.Changeset
  alias E2e.Form.Combobox

  embedded_schema do
    field :airport, :string
  end

  @doc false
  def change_combobox(%Combobox{} = combobox, attrs \\ %{}) do
    changeset(combobox, attrs)
  end

  @doc false
  def changeset(%Combobox{} = combobox, attrs) do
    combobox
    |> cast(attrs, [:airport])
    |> validate_required([:airport])
  end

  def changeset_validate(%Combobox{} = combobox, attrs \\ %{}) do
    combobox
    |> cast(attrs, [:airport])
    |> validate_required([:airport], message: "can't be blank")
  end
end
