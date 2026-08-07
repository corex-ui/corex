defmodule Corex.Url do
  @moduledoc false

  @spec allowed_href?(term()) :: boolean()
  def allowed_href?(destination) when is_binary(destination) do
    match?({:ok, _}, sanitize_href(destination))
  end

  def allowed_href?(_), do: false

  @spec put_data_to(map(), term()) :: map()
  def put_data_to(map, to) when is_map(map) and is_binary(to) do
    case sanitize_href(to) do
      {:ok, href} -> Map.put(map, "data-to", href)
      :error -> map
    end
  end

  def put_data_to(map, _) when is_map(map), do: map

  # WHATWG URL parsers strip leading C0 controls and space (codepoints ≤ 0x20)
  # before scheme detection. Align allowlisting with that so prefixed
  # `javascript:` / `data:` cannot bypass as a "relative" path.
  defp sanitize_href(destination) do
    case strip_leading_c0_and_space(destination) do
      "" -> :error
      trimmed -> if allowed_uri?(URI.parse(trimmed)), do: {:ok, trimmed}, else: :error
    end
  end

  defp strip_leading_c0_and_space(<<c, rest::binary>>) when c <= 0x20,
    do: strip_leading_c0_and_space(rest)

  defp strip_leading_c0_and_space(rest), do: rest

  defp allowed_uri?(%URI{scheme: nil, host: nil}), do: true

  defp allowed_uri?(%URI{scheme: scheme})
       when scheme in ["http", "https", "mailto", "tel"],
       do: true

  defp allowed_uri?(_), do: false
end
