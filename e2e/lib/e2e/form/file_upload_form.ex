defmodule E2e.Form.FileUploadForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :attachment, :map, virtual: true
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:attachment])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:attachment])
    |> validate_attachment_required()
  end

  defp validate_attachment_required(changeset) do
    upload = get_change(changeset, :attachment)

    if present_upload?(upload) do
      changeset
    else
      add_error(changeset, :attachment, "can't be blank", validation: :required)
    end
  end

  defp present_upload?(%Plug.Upload{filename: name}) when is_binary(name) and name != "", do: true
  defp present_upload?(_), do: false
end
