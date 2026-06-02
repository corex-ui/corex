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

  defp allowed_uri?(%URI{scheme: nil, host: nil}), do: true

  defp allowed_uri?(%URI{scheme: scheme}) when scheme in ["http", "https"], do: true

  defp allowed_uri?(_), do: false
end
