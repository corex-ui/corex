defmodule Corex.Design.AxisCssCoverageTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Selector
  alias Corex.Design.Taxonomy

  @skip_axes %{
    dialog_modal: ~w(width height max_width max_height)a,
    dialog_side: ~w(width height max_width max_height side)a,
    typo: Taxonomy.standard_axes(),
    link: [:variant],
    toggle: [:variant],
    action: [:variant]
  }

  test "each recipe emits BEM host rules for taxonomy-required axes" do
    offenders =
      for recipe <- Recipes.components(),
          axis <- Taxonomy.required_axes(recipe.id),
          axis not in skip_axes(recipe.id),
          axis in Recipe.axes(recipe),
          css = Recipe.to_css(recipe),
          not axis_emitted?(recipe, axis, css) do
        {recipe.id, axis}
      end

    assert offenders == [],
           "recipes missing axis CSS: #{inspect(offenders)}"
  end

  defp skip_axes(id), do: Map.get(@skip_axes, id, [])

  defp axis_emitted?(recipe, axis, css) do
    name = Selector.class_name(recipe.id)

    name
    |> axis_patterns(axis)
    |> Enum.any?(&String.contains?(css, &1))
  end

  defp axis_patterns(name, :semantic), do: [".#{name}.#{name}--semantic-accent"]
  defp axis_patterns(name, :size), do: [".#{name}.#{name}--size-sm"]
  defp axis_patterns(name, :text), do: [".#{name}.#{name}--text-base"]

  defp axis_patterns(name, :radius),
    do: [".#{name}.#{name}--rounded-md", ".#{name}.#{name}--rounded-none"]

  defp axis_patterns(name, :width), do: [".#{name}.#{name}--w-"]
  defp axis_patterns(name, :max_width), do: [".#{name}.#{name}--max-w-"]
  defp axis_patterns(name, :height), do: [".#{name}.#{name}--h-"]
  defp axis_patterns(name, :max_height), do: [".#{name}.#{name}--max-h-"]

  defp axis_patterns(name, :variant),
    do: [
      ".#{name}.#{name}--variant-solid",
      ".#{name}.#{name}--variant-ghost",
      ".#{name}.#{name}--variant-outline"
    ]

  defp axis_patterns(name, :shape), do: [".#{name}.#{name}--shape-square"]
  defp axis_patterns(_name, _axis), do: []
end
