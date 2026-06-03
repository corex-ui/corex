defmodule Corex.ComponentStyleContractTest do
  use ExUnit.Case, async: true

  @snapshot_path Path.join(__DIR__, "../support/component_style_snapshot.exs")

  test "component style metadata matches snapshot" do
    current = component_style_snapshot()
    expected = load_snapshot!()

    assert current == expected,
           "component style contract changed; update test/support/component_style_snapshot.exs if intentional"
  end

  defp component_style_snapshot do
    Corex.component_ids()
    |> Enum.flat_map(fn id ->
      case Corex.component_spec(id) do
        {:ok, %{module: mod_str}} ->
          mod = mod_str |> String.split(".") |> Module.safe_concat()
          Code.ensure_loaded!(mod)

          if function_exported?(mod, :__corex_style__, 0) do
            [{id, mod.__corex_style__()}]
          else
            []
          end

        :error ->
          []
      end
    end)
    |> Map.new()
  end

  defp load_snapshot! do
    @snapshot_path
    |> Code.eval_file()
    |> elem(0)
  end
end
