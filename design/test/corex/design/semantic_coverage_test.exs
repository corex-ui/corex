defmodule Corex.Design.SemanticCoverageTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Selector
  alias Corex.Design.Taxonomy

  @compound_visual ~W(button link toggle)a
  @skip_semantic ~W(badge timer avatar clipboard code data_list layout_heading marquee typo)a

  test "recipes with semantic axis emit accent scale-token styling" do
    offenders =
      for recipe <- Recipes.components(),
          semantic_axis?(recipe),
          not skip_semantic?(recipe.id),
          css = Recipe.to_css(recipe),
          not semantic_styled?(recipe, css) do
        recipe.id
      end

    assert offenders == [],
           "recipes missing semantic styling: #{inspect(offenders)}"
  end

  defp semantic_axis?(recipe) do
    :semantic in Recipe.axes(recipe)
  end

  defp skip_semantic?(id) do
    id in @skip_semantic or id in @compound_visual or Taxonomy.category_for(id) == :decorative
  end

  defp semantic_styled?(recipe, css) do
    name = Selector.class_name(recipe.id)
    utility = "@utility #{name}--semantic-*"

    has_host =
      String.contains?(css, utility) or
        String.contains?(css, ".#{name}.#{name}--semantic-accent")

    has_token =
      String.contains?(css, "--value(--color-*") or
        String.contains?(css, "--color-accent") or
        String.contains?(css, "--color-on-accent")

    has_host and has_token
  end
end
