defmodule Corex.Design.RecipesDiscoveryTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Recipes

  test "lists component recipe modules explicitly" do
    modules = Recipes.component_recipe_modules()

    assert Corex.Design.Recipes.Button in modules
    assert Corex.Design.Recipes.Accordion in modules
    assert Corex.Design.Recipes.Trigger not in modules
    assert Corex.Design.Recipes.FormHost not in modules
    assert length(modules) == 42
    assert modules == Enum.sort(modules)
  end

  test "every listed module implements recipe/0" do
    for module <- Recipes.component_recipe_modules() do
      assert {:module, _} = Code.ensure_loaded(module)
      assert match?(%Corex.Design.Recipe{}, module.recipe())
    end
  end
end
