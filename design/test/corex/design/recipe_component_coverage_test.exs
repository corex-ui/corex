defmodule Corex.Design.RecipeComponentCoverageTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes

  test "recipe styled axes are accepted by the matching component when it exists" do
    for recipe <- Recipes.components() do
      styled = MapSet.new(Recipe.styled_axes(recipe))

      case component_axes(recipe.id) do
        nil ->
          :ok

        component_axis_set ->
          unknown = MapSet.difference(styled, component_axis_set)

          assert MapSet.size(unknown) == 0,
                 "recipe #{recipe.id} styles #{inspect(MapSet.to_list(unknown))} but the component does not declare those axes"
      end
    end
  end

  defp component_axes(recipe_id) do
    case Corex.component_spec(recipe_id) do
      {:ok, %{module: mod_str}} ->
        mod = mod_str |> String.split(".") |> Module.safe_concat()
        Code.ensure_loaded!(mod)

        case mod.__corex_style__() do
          {base, axes} when is_binary(base) and is_list(axes) ->
            MapSet.new(axes)

          _ ->
            nil
        end

      :error ->
        nil
    end
  end
end
