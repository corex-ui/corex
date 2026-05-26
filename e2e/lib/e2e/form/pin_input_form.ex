defmodule E2e.Form.PinInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :pin, {:array, :string}
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:pin])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:pin])
    |> validate_required([:pin], message: "can't be blank")
    |> validate_length(:pin, is: 4, message: "must be 4 digits")
    |> validate_pin_digits()
  end

  defp validate_pin_digits(changeset) do
    case get_field(changeset, :pin) do
      pin when is_list(pin) ->
        if Enum.all?(pin, &(is_binary(&1) and String.length(&1) == 1)) do
          changeset
        else
          add_error(changeset, :pin, "must be one character per digit")
        end

      _ ->
        changeset
    end
  end
end
