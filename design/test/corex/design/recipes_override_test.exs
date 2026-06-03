defmodule Corex.Design.RecipesOverrideTest do
  use ExUnit.Case, async: false

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes

  defmodule Source do
    @behaviour Corex.Design.RecipeSource

    @impl true
    def recipes do
      [
        Recipe.component(:button, base: %{color: "red"}),
        Recipe.layout(:custom_widget, base: [])
      ]
    end
  end

  setup do
    original = Application.get_env(:corex_design, :recipes)
    original_include = Application.get_env(:corex_design, :include_recipes)

    on_exit(fn ->
      restore(:recipes, original)
      restore(:include_recipes, original_include)
    end)

    :ok
  end

  defp restore(key, nil), do: Application.delete_env(:corex_design, key)
  defp restore(key, value), do: Application.put_env(:corex_design, key, value)

  test "merges host recipes by id: replaces built-in in place and appends new" do
    Application.put_env(:corex_design, :recipes, [Source])

    all = Recipes.all()
    button = Enum.find(all, &(&1.id == :button))

    assert button.base == %{color: "red"}
    assert Enum.count(all, &(&1.id == :button)) == 1
    assert Enum.any?(all, &(&1.id == :custom_widget))
  end

  test "without config, all/0 is built-ins only" do
    Application.delete_env(:corex_design, :recipes)

    refute Enum.any?(Recipes.all(), &(&1.id == :custom_widget))
  end

  test "raises for a module that does not implement RecipeSource" do
    Application.put_env(:corex_design, :recipes, [Enum])

    assert_raise ArgumentError, ~r/recipes\/0/, fn -> Recipes.all() end
  end

  test "raises when recipes/0 returns a non-Recipe value" do
    defmodule BadSource do
      def recipes, do: [:not_a_recipe]
    end

    Application.put_env(:corex_design, :recipes, [BadSource])

    assert_raise ArgumentError, ~r/%Corex.Design.Recipe\{\}/, fn -> Recipes.all() end
  end

  test "emitted/0 defaults to the full recipe set" do
    Application.delete_env(:corex_design, :include_recipes)

    assert length(Recipes.emitted()) == length(Recipes.all())
  end

  test "include_recipes filters emitted/0 without shrinking all/0" do
    Application.put_env(:corex_design, :include_recipes, [:button, :link])

    emitted_ids = Enum.map(Recipes.emitted(), & &1.id)

    assert Enum.sort(emitted_ids) == [:button, :link]
    assert length(Recipes.all()) > 2
  end

  test "host recipe override changes compiled button CSS" do
    Application.put_env(:corex_design, :recipes, [Source])

    css = Corex.Design.Compiler.compile_recipe(Recipes.all() |> Enum.find(&(&1.id == :button)))

    assert css =~ "red"
  end
end
