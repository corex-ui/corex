defmodule Corex.ComponentStyleContractTest do
  use ExUnit.Case, async: true

  alias CorexTest.ComponentStyleSnapshot

  test "component style metadata matches snapshot" do
    current = component_style_snapshot()
    expected = ComponentStyleSnapshot.expected()

    assert current == expected,
           "component style contract changed; update test/support/component_style_snapshot.ex if intentional"
  end

  defp component_style_snapshot do
    Corex.component_ids()
    |> Enum.flat_map(&style_entry/1)
    |> Map.new()
  end

  defp style_entry(id) do
    case Corex.component_spec(id) do
      {:ok, %{module: mod_str}} -> style_entry_for_module(id, mod_str)
      :error -> []
    end
  end

  defp style_entry_for_module(id, mod_str) do
    mod = mod_str |> String.split(".") |> Module.safe_concat()
    Code.ensure_loaded!(mod)

    if function_exported?(mod, :__corex_style__, 0) do
      [{id, mod.__corex_style__()}]
    else
      []
    end
  end
end
