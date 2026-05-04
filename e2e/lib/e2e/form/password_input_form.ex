defmodule E2e.Form.PasswordInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :password, :string, redact: true
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:password])
    |> validate_required(:password)
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:password])
    |> validate_required([:password], message: "can't be blank")
    |> validate_length(:password, min: 8, message: "must be at least 8 characters")
  end
end
