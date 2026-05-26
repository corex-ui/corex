defmodule E2e.Form.SignatureForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :signature, {:array, :string}
  end

  def changeset(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:signature])
    |> validate_required([:signature])
  end

  def changeset_validate(form, attrs \\ %{}) do
    form
    |> cast(attrs, [:signature])
    |> validate_required([:signature], message: "can't be blank")
    |> validate_signature_present()
  end

  defp validate_signature_present(changeset) do
    signature =
      changeset
      |> get_field(:signature)
      |> List.wrap()
      |> Enum.reject(&(&1 == ""))

    if signature == [], do: add_error(changeset, :signature, "can't be blank"), else: changeset
  end

  @path_printable_limit 48

  def format_for_toast(%__MODULE__{signature: signature}), do: format_for_toast(signature)

  def format_for_toast(signature) do
    paths = normalize_paths(signature)

    "signature=#{inspect(paths, printable_limit: @path_printable_limit, limit: :infinity)}"
  end

  defp normalize_paths(nil), do: []
  defp normalize_paths(""), do: []

  defp normalize_paths(paths) when is_list(paths) do
    Enum.flat_map(paths, fn
      d when is_binary(d) and d != "" -> [d]
      _ -> []
    end)
  end

  defp normalize_paths(signature) when is_binary(signature) do
    case Jason.decode(signature) do
      {:ok, paths} when is_list(paths) ->
        normalize_paths(paths)

      _ ->
        signature
        |> String.split("\n")
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))
    end
  end
end
