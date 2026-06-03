defmodule Corex.Design.Styles do
  @moduledoc false

  alias Corex.Design.PartTree
  alias Corex.Design.Recipe

  @doc """
  Returns style trees from `config :corex_design, styles:`.
  """
  def config do
    :corex_design
    |> Application.get_env(:styles, %{})
    |> normalize_map()
  end

  @doc """
  Appends compiled part-tree override rules to a recipe from global and per-id config.
  """
  def apply_recipe(%Recipe{id: id} = recipe) do
    case Map.get(config(), id) do
      nil ->
        recipe

      spec when is_map(spec) ->
        {global_tree, instances} = split_spec(spec)

        global_rules =
          if global_tree && global_tree != %{} do
            PartTree.compile_rules(id, global_tree)
          else
            []
          end

        instance_rules =
          Enum.flat_map(instances, fn {host_id, tree} ->
            PartTree.compile_rules(id, tree, host_id: host_id)
          end)

        %{recipe | extra_rules: (recipe.extra_rules || []) ++ global_rules ++ instance_rules}
    end
  end

  defp split_spec(%{all: all, instances: instances}) when is_map(instances) do
    {all, instances}
  end

  defp split_spec(spec) when is_map(spec) do
    case Map.pop(spec, :instances) do
      {nil, rest} -> {rest, %{}}
      {instances, rest} -> {Map.get(rest, :all, rest), instances}
    end
  end

  defp normalize_map(map) when is_map(map) do
    Map.new(map, fn {key, value} ->
      {normalize_component_key(key), normalize_component_spec(value)}
    end)
  end

  defp normalize_component_key(key) when is_atom(key), do: key

  defp normalize_component_key(key) when is_binary(key) do
    try do
      String.to_existing_atom(key)
    rescue
      ArgumentError -> String.to_atom(key)
    end
  end

  defp normalize_component_spec(%{instances: _} = spec) when is_map(spec), do: spec

  defp normalize_component_spec(spec) when is_map(spec) do
    Map.new(spec, fn {key, value} ->
      {normalize_instance_key(key), value}
    end)
  end

  defp normalize_instance_key(:all), do: :all
  defp normalize_instance_key(:instances), do: :instances
  defp normalize_instance_key(key) when is_binary(key), do: key

  defp normalize_instance_key(key) when is_atom(key), do: key
end
