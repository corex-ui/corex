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

  def put_attachment_label(attrs, names) when is_map(attrs) and is_list(names) do
    case names do
      [] -> attrs
      names -> Map.put(attrs, "attachment_label", Enum.join(names, ", "))
    end
  end

  defp validate_attachment_required(changeset) do
    params = changeset.params || %{}

    upload =
      get_change(changeset, :attachment) ||
        Map.get(params, "attachment")

    label = Map.get(params, "attachment_label")

    if present_upload?(upload) or present_label?(label) do
      changeset
    else
      add_error(changeset, :attachment, "can't be blank", validation: :required)
    end
  end

  defp present_upload?(%Plug.Upload{filename: name}) when is_binary(name) and name != "", do: true
  defp present_upload?(_), do: false

  defp present_label?(label) when is_binary(label), do: String.trim(label) != ""
  defp present_label?(_), do: false

  def names_label(nil), do: "(none)"

  def names_label(%Plug.Upload{filename: name}) when is_binary(name) and name != "",
    do: name

  def names_label(names) when is_list(names) do
    names
    |> Enum.map(&names_label/1)
    |> Enum.reject(&(&1 == "(none)"))
    |> case do
      [] -> "(none)"
      labels -> Enum.join(labels, ", ")
    end
  end

  def names_label(name) when is_binary(name) and name != "", do: name
  def names_label(_), do: "(none)"

  def names_from_event(%{"acceptedNames" => names}) when is_list(names), do: names_label(names)

  def names_from_event(%{"firstAcceptedName" => name}) when is_binary(name) and name != "",
    do: name

  def names_from_event(_), do: "(none)"

  def submit_label(upload, nested, label_field) do
    case upload do
      %Plug.Upload{} = plug_upload ->
        names_label(plug_upload)

      _ ->
        nested
        |> Map.get(label_field)
        |> names_label()
    end
  end

  def label_field_for("attachment"), do: "attachment_label"
  def label_field_for("avatar"), do: "avatar_label"
  def label_field_for(field), do: "#{field}_label"
end
