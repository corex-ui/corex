defmodule Corex.Design.CompilerIntegrationTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Compiler
  alias Corex.Design.Recipes

  @output "assets/css/corex.tailwind.css"

  setup do
    original = CorexDesign.TestConfig.snapshot()

    on_exit(fn ->
      CorexDesign.TestConfig.restore(original)
    end)

    :ok
  end

  test "include_recipes shrinks recipe aggregate output" do
    CorexDesign.TestConfig.put(output: @output)
    full = Compiler.tailwind_recipes_css()

    CorexDesign.TestConfig.put(
      output: @output,
      recipes: [include: [:button]]
    )

    filtered = Compiler.tailwind_recipes_css()

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
    tmp =
      System.tmp_dir!() |> Path.join("corex_design_test_#{System.unique_integer([:positive])}")

    on_exit(fn -> File.rm_rf(tmp) end)

    CorexDesign.TestConfig.put(output: Path.join(tmp, "corex.tailwind.css"))

    Corex.Design.compile()

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
