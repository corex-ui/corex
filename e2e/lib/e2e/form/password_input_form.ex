defmodule E2e.Form.PasswordInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :password, :string
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:password])
  end
end
