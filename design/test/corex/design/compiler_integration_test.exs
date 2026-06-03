defmodule Corex.Design.CompilerIntegrationTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Compiler
  alias Corex.Design.Recipes

  setup do
    original = Application.get_env(:corex_design, :include_recipes)

    on_exit(fn ->
      restore(:include_recipes, original)
    end)

    :ok
  end

  defp restore(key, nil), do: Application.delete_env(:corex_design, key)
  defp restore(key, value), do: Application.put_env(:corex_design, key, value)

  test "include_recipes shrinks full compile output" do
    Application.delete_env(:corex_design, :include_recipes)
    full = Compiler.compile()

    Application.put_env(:corex_design, :include_recipes, [:button])
    filtered = Compiler.compile()

    assert byte_size(filtered) < byte_size(full)
    assert filtered =~ "button"
    refute filtered =~ "accordion"
  end

  test "recipe export emits BEM selectors" do
    css = Compiler.compile_recipe(Enum.find(Recipes.components(), &(&1.id == :button)))

    assert css =~ ".button"
    refute css =~ "[data-button-semantic"
  end

  test "bundle writes modular folders when output is configured" do
    tmp = System.tmp_dir!() |> Path.join("corex_design_test_#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf(tmp) end)

    Application.put_env(:corex_design, :compile_test, output: Path.join(tmp, "corex.tailwind.css"))

    Corex.Design.compile(profile: :compile_test)

    for name <- [
          "corex.tailwind.css",
          "corex.tailwind.theme.css",
          "corex.tailwind.base.css",
          "corex.tokens.css",
          "layers/theme.css",
          "layers/base.css",
          "layers/tokens.css",
          "recipes/button.css",
          "recipes/row.css",
          "aggregates/recipes.css"
        ] do
      assert File.exists?(Path.join(tmp, name))
    end
  end
end
