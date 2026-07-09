defmodule Corex.Design.Filter do
  @moduledoc false

  alias Corex.Design.ComponentLayout

  @default_semantics ~w(base accent brand alert info success)a
  @default_variants ~w(solid ghost outline)a

  @installer_components ~w(
    toast layout-heading typo icon link button dialog password-input scrollbar
    checkbox data-list data-table date-picker native-input number-input select
    toggle
  )a

  def default_semantics, do: @default_semantics
  def default_variants, do: @default_variants
  def default_installer_components, do: @installer_components

  def components do
    Corex.Design.design_config()
    |> Map.get(:components)
    |> normalize_component_list()
  end

  def semantics do
    Corex.Design.design_config()
    |> resolved_semantics()
    |> Enum.uniq()
  end

  def variants do
    Corex.Design.design_config()
    |> Map.get(:variants)
    |> normalize_variant_list()
  end

  def all_components?, do: is_nil(components())
  def all_semantics?, do: semantics() == Enum.map(@default_semantics, &Atom.to_string/1)
  def all_variants?, do: is_nil(variants())

  def validate_component_ids!(ids) when is_list(ids) do
    allowed = MapSet.new(ComponentLayout.ids())

    invalid =
      ids
      |> Enum.map(&to_string/1)
      |> Enum.reject(&MapSet.member?(allowed, &1))

    case invalid do
      [] ->
        :ok

      _ ->
        raise ArgumentError,
              "config :corex_design, components: unknown ids #{inspect(invalid)}; allowed: #{inspect(ComponentLayout.ids())}"
    end
  end

  def validate_semantics!(roles) when is_list(roles) do
    allowed =
      @default_semantics
      |> Enum.map(&Atom.to_string/1)
      |> MapSet.new()

    invalid =
      roles
      |> Enum.map(&to_string/1)
      |> Enum.reject(&MapSet.member?(allowed, &1))

    case invalid do
      [] ->
        :ok

      _ ->
        raise ArgumentError,
              "config :corex_design, semantics: unknown roles #{inspect(invalid)}; allowed: #{inspect(MapSet.to_list(allowed))}"
    end
  end

  def validate_variants!(names) when is_list(names) do
    allowed =
      @default_variants
      |> Enum.map(&Atom.to_string/1)
      |> MapSet.new()

    invalid =
      names
      |> Enum.map(&normalize_variant/1)
      |> Enum.reject(&MapSet.member?(allowed, &1))

    case invalid do
      [] ->
        :ok

      _ ->
        raise ArgumentError,
              "config :corex_design, variants: unknown names #{inspect(invalid)}; allowed: #{inspect(Enum.map(@default_variants, &Atom.to_string/1))}"
    end
  end

  defp normalize_component_list(nil), do: nil

  defp normalize_component_list(list) when is_list(list) do
    list
    |> Enum.map(&to_string/1)
    |> Enum.uniq()
  end

  defp normalize_variant_list(nil), do: nil

  defp normalize_variant_list(list) when is_list(list) do
    list
    |> Enum.map(&normalize_variant/1)
    |> Enum.uniq()
  end

  defp normalize_variant(atom) when is_atom(atom), do: Atom.to_string(atom)
  defp normalize_variant(string) when is_binary(string), do: string

  defp resolved_semantics(config) when is_map(config) do
    cond do
      roles = Map.get(config, :semantics) ->
        roles
        |> normalize_semantic_list()
        |> ensure_base()

      scales_semantic(config) ->
        scales_semantic(config)
        |> normalize_semantic_list()
        |> ensure_base()

      true ->
        Enum.map(@default_semantics, &Atom.to_string/1)
    end
  end

  defp scales_semantic(config) do
    config
    |> Map.get(:scales, [])
    |> normalize_scales()
    |> Keyword.get(:semantic)
  end

  defp normalize_scales(list) when is_list(list), do: list
  defp normalize_scales(map) when is_map(map), do: Map.to_list(map)
  defp normalize_scales(_), do: []

  defp normalize_semantic_list(list) when is_list(list) do
    Enum.map(list, fn
      role when is_atom(role) -> Atom.to_string(role)
      role when is_binary(role) -> role
    end)
  end

  defp ensure_base(roles) do
    if "base" in roles, do: roles, else: ["base" | roles]
  end
end
