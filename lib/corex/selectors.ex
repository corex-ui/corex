defmodule Corex.Selectors do
  @moduledoc false

  @spec css_id(String.t()) :: String.t()
  def css_id(id) when is_binary(id) do
    "##{escape_css_identifier(id)}"
  end

  defp escape_css_identifier(id) when is_binary(id) do
    id
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.map(fn
      {ch, idx} when ch in ?a..?z or ch in ?A..?Z or ch in ?0..?9 or ch == ?- or ch == ?_ ->
        if idx == 0 and ch in ?0..?9 do
          ["\\", Integer.to_string(ch, 16), " "]
        else
          <<ch::utf8>>
        end

      {ch, _idx} ->
        ["\\", <<ch::utf8>>]
    end)
    |> IO.iodata_to_binary()
  end
end
