defmodule Corex.Design.TaxonomyTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Recipes.Button
  alias Corex.Design.Recipes.Checkbox
  alias Corex.Design.Recipes.DialogSide
  alias Corex.Design.Recipes.Marquee
  alias Corex.Design.Recipes.TreeView
  alias Corex.Design.Taxonomy

  @deprecated_axes ~W(color rounded visual on)a

  test "recipes use canonical axis names" do
    for recipe <- Recipes.components() do
      for axis <- Recipe.axes(recipe) do
        refute axis in @deprecated_axes,
               "#{recipe.id} still exposes deprecated axis #{inspect(axis)}"
      end
    end
  end

  test "pilot components expose core axes" do
    assert :semantic in Recipe.axes(Button.recipe())
    assert :variant in Recipe.axes(Button.recipe())
    assert :radius in Recipe.axes(Checkbox.recipe())
    assert :side in Recipe.axes(DialogSide.recipe())
    assert :semantic in Recipe.axes(Marquee.recipe())
    assert :semantic in Recipe.axes(TreeView.recipe())
  end

  test "standard axis names are documented" do
    assert :semantic in Taxonomy.standard_axes()
    assert :radius in Taxonomy.standard_axes()
    assert :variant in Taxonomy.standard_axes()
    refute :color in Taxonomy.standard_axes()
    refute :rounded in Taxonomy.standard_axes()
  end
end
