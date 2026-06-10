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
    accent_host = ".#{name}.#{name}--semantic-accent"
    compound = ".#{name}.#{name}--variant-solid.#{name}--semantic-accent"

    has_host = String.contains?(css, accent_host) or String.contains?(css, compound)

    has_token =
      String.contains?(css, "--color-accent") or
        String.contains?(css, "--color-ui-ink-accent") or
        String.contains?(css, "--color-accent-ink")

    has_host and has_token
  end
end
