defmodule Corex.ItemBuilder do
  @moduledoc false

  def generate_id(prefix) when is_binary(prefix) do
    "#{prefix}-#{System.unique_integer([:positive])}"
  end

  def build_item(module, attrs, opts \\ []) when is_atom(module) do
    index = Keyword.get(opts, :index)
    id_prefix = Keyword.get(opts, :id_prefix)
    required_fields = Keyword.fetch!(opts, :required_fields)
    optional_fields = Keyword.get(opts, :optional_fields, [])
    example = Keyword.fetch!(opts, :example)

    try do
      attrs =
        attrs
        |> normalize_attrs()
        |> maybe_put_index_value(index, id_prefix)

      struct!(module, attrs)
    rescue
      e in [KeyError, ArgumentError] ->
        reraise ArgumentError,
                """
                Failed to create #{inspect(module)}: #{Exception.message(e)}

                Required fields: #{inspect(required_fields)}
                Optional fields: #{inspect(optional_fields)}

                Example:
                  #{example}
                """,
                __STACKTRACE__
    end
  end

  defp normalize_attrs(attrs) when is_map(attrs), do: attrs

  defp normalize_attrs(attrs) when is_list(attrs) do
    if Keyword.keyword?(attrs) do
      Enum.into(attrs, %{})
    else
      attrs
    end
  end

  defp maybe_put_index_value(attrs, nil, nil), do: attrs

  defp maybe_put_index_value(attrs, index, _prefix) when is_integer(index) do
    Map.put_new(attrs, :value, "item-#{index}")
  end

  defp maybe_put_index_value(attrs, _index, prefix) when is_binary(prefix) do
    Map.put_new_lazy(attrs, :value, fn -> generate_id(prefix) end)
  end
end
