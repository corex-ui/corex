defmodule E2e.Form.TagsInputForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :tags, :string
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
    |> validate_format(:tags, ~r/^[^;]+$/, message: "must not contain semicolons")
    |> validate_tag_count(:tags, 3)
  end

  defp validate_tag_count(changeset, field, max) do
    validate_change(changeset, field, fn _, value ->
      n = value |> String.split(",", trim: true) |> length()
      if n <= max, do: [], else: [{field, "must have at most #{max} tags"}]
    end)
  end
end
