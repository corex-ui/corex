defmodule Corex.Design.BemRecipeAxisContractTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Taxonomy

  @components_dir Path.expand("../../../../lib/components", __DIR__)

  @registry_to_recipe %{
    action: :button,
    navigate: :link
  }

  test "registry ids map to recipes covering taxonomy required axes" do
    recipes = Map.new(Recipes.components(), &{&1.id, &1})

    for {registry_id, recipe_id} <- @registry_to_recipe do
      recipe = Map.fetch!(recipes, recipe_id)
      exposed = MapSet.new(Recipe.axes(recipe))

      for axis <- Taxonomy.required_axes(registry_id) do
        assert axis in exposed,
               "#{registry_id} -> #{recipe_id} recipe missing taxonomy axis #{inspect(axis)}"
      end
    end
  end

  test "component Bem.Variants axes cover taxonomy required axes" do
    for {registry_id, axes} <- component_axes_by_registry() do
      exposed = MapSet.new(axes)

      for axis <- Taxonomy.required_axes(registry_id) do
        assert axis in exposed,
               "#{registry_id} component axes missing taxonomy axis #{inspect(axis)}"
      end
    end
  end

  defp component_axes_by_registry do
    @components_dir
    |> Path.join("*.ex")
    |> Path.wildcard()
    |> Enum.flat_map(&parse_component_axes/1)
  end

  defp parse_component_axes(path) do
    content = File.read!(path)
    registry_id = path |> Path.basename() |> Path.rootname() |> String.to_atom()

    case Regex.run(~r/axes:\s*\[([^\]]+)\]/, content, capture: :all_but_first) do
      [axes_blob] ->
        axes =
          axes_blob
          |> String.split(",")
          |> Enum.map(&String.trim/1)
          |> Enum.reject(&(&1 == ""))
          |> Enum.map(fn segment ->
            segment
            |> String.trim_leading(":")
            |> String.to_atom()
          end)

        [{registry_id, axes}]

      _ ->
        []
    end
  end
end
