defmodule E2e.Form.TagsInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :tags, {:array, :string}
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:tags])
    |> validate_required([:tags])
    |> validate_tag_count(:tags, 3)
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:tags])
    |> validate_required([:tags], message: "can't be blank")
    |> validate_length(:tags, min: 1, message: "can't be blank")
    |> validate_tag_list(:tags, 3)
  end

  defp validate_tag_count(changeset, field, max) do
    validate_change(changeset, field, fn _, value ->
      n = if is_list(value), do: length(value), else: 0
      if n <= max, do: [], else: [{field, "must have at most #{max} tags"}]
    end)
  end

  defp validate_tag_list(changeset, field, max) do
    validate_change(changeset, field, fn _, value ->
      cond do
        not is_list(value) ->
          [{field, "is invalid"}]

        length(value) > max ->
          [{field, "must have at most #{max} tags"}]

        Enum.any?(value, &String.contains?(&1, ";")) ->
          [{field, "must not contain semicolons"}]

        true ->
          []
      end
    end)
  end
end
