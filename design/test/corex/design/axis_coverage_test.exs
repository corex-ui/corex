defmodule Corex.Design.AxisCoverageTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Taxonomy

  test "each registered component exposes its category required axes" do
    for recipe <- Recipes.components() do
      required = Taxonomy.required_axes(recipe.id)
      exposed = MapSet.new(Recipe.axes(recipe))

      for axis <- required do
        assert axis in exposed,
               "#{recipe.id} is missing required axis #{inspect(axis)} (category #{inspect(Taxonomy.category_for(recipe.id))})"
      end
    end
  end
end
