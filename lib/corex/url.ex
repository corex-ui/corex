defmodule Corex.Url do
  @moduledoc false

  @spec allowed_href?(String.t()) :: boolean()
  def allowed_href?(destination) when is_binary(destination) do
    case String.trim(destination) do
      "" -> false
      trimmed -> allowed_uri?(URI.parse(trimmed))
    end
  end

  def allowed_href?(_), do: false

  @spec put_data_to(map(), term()) :: map()
  def put_data_to(map, to) when is_map(map) and is_binary(to) do
    if allowed_href?(to), do: Map.put(map, "data-to", to), else: map
  end

  def put_data_to(map, _) when is_map(map), do: map

  defp allowed_uri?(%URI{scheme: nil, host: nil}), do: true

  defp allowed_uri?(%URI{scheme: scheme}) when scheme in ["http", "https"], do: true

  defp allowed_uri?(_), do: false
end
