defmodule Corex.Design.Recipe do
  @moduledoc """
  Recipe struct and builders for the design CSS layer.

  Styling splits into two layers:

  1. **Host modifiers** — axes (`semantic`, `size`, `variant`, …) stamped as BEM
     classes on the component host via `Corex.Variants`.
  2. **Part rules** — CSS targeting `[data-scope][data-part]` descendants via
     `extra_rules` and optional per-part variant blocks.

  Component HEEx structure is unrelated; only stable part names from the Zag
  contract matter for Layer 2.
  """

  alias Corex.Design.RecipePresets
  alias Corex.Design.Style

  @enforce_keys [:id]
  defstruct id: nil,
            kind: :layout,
            scope: nil,
            base: [],
            variants: [],
            axis_overrides: [],
            default_variants: [],
            extra_rules: []

  @type props :: keyword()
  @type t :: %__MODULE__{
          id: atom(),
          kind: :layout | :style_recipe | :style_part_recipe,
          scope: binary() | nil,
          base: term(),
          variants: term(),
          axis_overrides: [map()],
          default_variants: keyword(),
          extra_rules: [term()]
        }

  @doc """
  Builds a layout-style recipe from a keyword definition (base + variant axes).
  Emits a single data-attribute selector contract (`[data-<id>]`,
  `[data-<id>-<axis>="<value>"]`).
  """
  def new(id, opts) do
    %__MODULE__{
      id: id,
      base: Keyword.get(opts, :base, []),
      variants: Keyword.get(opts, :variants, []),
      default_variants: Keyword.get(opts, :default_variants, []),
      extra_rules: Keyword.get(opts, :extra_rules, [])
    }
  end

  @doc """
  Defines a Panda-style single-element recipe: a structural `base`, named
  `variants` (`%{axis => [{value, block}]}`), `axis_overrides`, and
  `default_variants`. A `block` is an sx map (or a bare keyword of decls). Emits
  the `[data-<id>]` / `[data-<id>-<axis>="v"]` contract.
  """
  def define(id, opts) do
    host_sizing = Keyword.get(opts, :host_sizing, RecipePresets.default_host_sizing())
    variants = opts |> Keyword.get(:variants, []) |> RecipePresets.merge_define_sizing_variants()
    default_variants = Keyword.merge(host_sizing, Keyword.get(opts, :default_variants, []))
    base = opts |> Keyword.get(:base, %{}) |> RecipePresets.strip_define_sizing_base()

    %__MODULE__{
      id: id,
      kind: Keyword.get(opts, :kind, :style_recipe),
      base: base,
      variants: variants,
      axis_overrides: axis_overrides_from(opts),
      default_variants: default_variants,
      extra_rules: Keyword.get(opts, :extra_rules, [])
    }
  end

  @doc """
  Defines a multi-part recipe. `base` and each variant value are keyword lists
  of `{part, block}` where `:host` is the `[data-<id>]` wrapper and any other
  part is `[data-scope="<scope>"][data-part="<part>"]` nested under it.
  """
  def part_recipe(id, opts) do
    host_sizing = Keyword.get(opts, :host_sizing, RecipePresets.default_host_sizing())
    variants = opts |> Keyword.get(:variants, []) |> RecipePresets.merge_host_sizing_variants()
    default_variants = Keyword.merge(host_sizing, Keyword.get(opts, :default_variants, []))
    base = opts |> Keyword.get(:base, []) |> RecipePresets.strip_host_sizing_base()

    %__MODULE__{
      id: id,
      kind: Keyword.get(opts, :kind, :style_part_recipe),
      scope: Keyword.fetch!(opts, :scope),
      base: base,
      variants: variants,
      axis_overrides: axis_overrides_from(opts),
      default_variants: default_variants,
      extra_rules: Keyword.get(opts, :extra_rules, [])
    }
  end

  def slot_recipe(id, opts), do: part_recipe(id, opts)

  @doc """
  Returns the style axes (variant names) a recipe exposes.
  """
  def axes(%__MODULE__{variants: variants}), do: Keyword.keys(variants)

  @doc """
  Axes this recipe emits CSS for. May be a subset of the matching component's
  accepted axes (see `Corex.Variants`).
  """
  def styled_axes(recipe), do: axes(recipe)

  @doc "Returns `[{axis, [values]}]` for a recipe variant map."
  def variant_map(%__MODULE__{variants: variants}) do
    for {axis, values} <- variants, do: {axis, Enum.map(values, fn {v, _} -> to_string(v) end)}
  end

  @doc """
  Returns the recipe host base sx map (or slot base map) with `default_variants`
  merged in so bare block-class hosts render default styling without modifiers.
  """
  def resolved_base(%__MODULE__{} = recipe) do
    case recipe.kind do
      kind when kind in [:style_part_recipe, :slot_recipe, :style_slot_recipe] ->
        resolve_part_base(recipe)

      _ ->
        resolve_host_base(recipe)
    end
  end

  defp resolve_host_base(recipe) do
    recipe.base
    |> sx_map()
    |> merge_default_variants(recipe.variants, recipe.default_variants)
  end

  defp resolve_part_base(recipe) do
    base_slots = slot_base_entries(recipe.base)

    Enum.reduce(recipe.default_variants, base_slots, fn {axis, value}, slots ->
      case lookup_variant_block(recipe.variants, axis, value) do
        nil -> slots
        block -> merge_slot_variant(slots, block)
      end
    end)
  end

  defp merge_default_variants(base, variants, default_variants) do
    Enum.reduce(default_variants, base, fn {axis, value}, acc ->
      case lookup_variant_block(variants, axis, value) do
        nil -> acc
        block -> Style.merge(acc, sx_map(block))
      end
    end)
  end

  defp merge_slot_variant(slots, variant_block) when is_list(variant_block) do
    Enum.reduce(variant_block, slots, fn {slot, block}, acc ->
      current = Map.get(acc, slot, %{})
      Map.put(acc, slot, Style.merge(current, sx_map(block)))
    end)
  end

  defp merge_slot_variant(slots, variant_block) when is_map(variant_block) do
    if Map.has_key?(variant_block, :host) or Map.has_key?(variant_block, "host") do
      merge_slot_variant(slots, Map.to_list(variant_block))
    else
      Map.update(slots, :host, sx_map(variant_block), &Style.merge(&1, sx_map(variant_block)))
    end
  end

  defp merge_slot_variant(slots, _variant_block), do: slots

  defp lookup_variant_block(variants, axis, value) do
    case Keyword.get(variants, axis) do
      nil ->
        nil

      pairs ->
        Enum.find_value(pairs, fn {candidate, block} ->
          if variant_value?(candidate, value), do: block
        end)
    end
  end

  defp variant_value?(left, right), do: to_string(left) == to_string(right)

  defp slot_base_entries(base) when is_list(base), do: Map.new(base, fn {slot, sx} -> {slot, sx_map(sx)} end)
  defp slot_base_entries(base) when is_map(base), do: Map.new(base, fn {slot, sx} -> {slot, sx_map(sx)} end)

  defp sx_map(%{} = map), do: map
  defp sx_map([]), do: %{}
  defp sx_map(list) when is_list(list), do: Map.new(list)

  @doc """
  Renders the recipe to Tailwind component-layer CSS.
  """
  def to_css(%__MODULE__{} = recipe) do
    alias Corex.Design.Emit.TailwindRecipe

    TailwindRecipe.to_css(recipe)
  end

  @doc false
  def component(id, opts), do: define(id, opts)

  @doc false
  def slotted(id, opts), do: part_recipe(id, opts)

  defp axis_overrides_from(opts) do
    opts
    |> Keyword.get(:axis_overrides, Keyword.get(opts, :compound_variants, []))
    |> List.wrap()
  end

  @doc false
  def layout(id, opts), do: new(id, opts)

  @doc """
  Deep-merges variant maps into a recipe (host overrides).
  """
  def merge_variants(%__MODULE__{} = recipe, overrides) when is_list(overrides) do
    merged =
      Enum.reduce(overrides, recipe.variants, fn {axis, values}, variants ->
        existing = Keyword.get(variants, axis, [])

        merged_values =
          Enum.reduce(values, Map.new(existing), fn {value, block}, acc ->
            Map.put(acc, value, deep_merge_block(Map.get(existing, value), block))
          end)
          |> Enum.to_list()

        Keyword.put(variants, axis, merged_values)
      end)

    %{recipe | variants: merged}
  end

  defp deep_merge_block(nil, block), do: block
  defp deep_merge_block(block, nil), do: block

  defp deep_merge_block(existing, block) when is_map(existing) and is_map(block) do
    Map.merge(existing, block, fn _k, left, right ->
      if is_map(left) and is_map(right), do: Map.merge(left, right), else: right
    end)
  end

  defp deep_merge_block(_existing, block), do: block
end

defmodule Corex.Design.RecipeBehaviour do
  @moduledoc """
  Behaviour for built-in and host component stylesheets.

  Implement `recipe/0` returning a `%Corex.Design.Recipe{}` struct.
  """

  @callback recipe() :: Corex.Design.Recipe.t()
end

defmodule Corex.Design.RecipeSource do
  @moduledoc """
  Behaviour for host-provided recipe overrides and additions.

  Implement `recipes/0` to return a list of `%Corex.Design.Recipe{}` (built with
  `Corex.Design.Recipe.component/2`, `slotted/2`, `layout/2`, or the legacy
  `define/2`, `slot_recipe/2`, `new/2`) and register the module under the design
  pipeline config:

      config :corex_design, recipes: [MyApp.Design.Recipes]

  Host recipes are merged into `Corex.Design.Recipes.all/0` by `:id`: a host
  recipe whose id matches a built-in replaces it in place; a recipe with a new id
  is appended. Editing a registered recipe regenerates `corex.tailwind.css` on the next
  `mix compile` (the resolved recipes are part of the compiler digest).
  """

  @callback recipes() :: [Corex.Design.Recipe.t()]
end
