defmodule E2e.Form.ColorPickerForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :color, :string, default: "#3b82f6"
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:color])
    |> validate_required([:color])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:color])
    |> validate_required([:color])
    |> validate_alpha_max_50()
  end

  defp validate_alpha_max_50(changeset) do
    case get_field(changeset, :color) do
      nil ->
        changeset

      value ->
        case Regex.run(~r/rgba?\(\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*([\d.]+)\s*\)/, value) do
          [_, a] ->
            case Float.parse(a) do
              {float_val, _} ->
                if float_val > 0.5 do
                  add_error(changeset, :color, "maximum alpha allowed is 50%")
                else
                  changeset
                end

              :error ->
                changeset
            end

          _ ->
            changeset
        end
    end
  end
end
