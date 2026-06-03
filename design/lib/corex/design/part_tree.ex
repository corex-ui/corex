defmodule Corex.Design.PartTree do
  @moduledoc false

  alias Corex.Design.PartTree.Compiler

  @state_keys ~w(base open closed hover focus focus_visible active)a
  @reserved_keys @state_keys ++ ~w(unset icons match)a

  @doc """
  Deep-merges two part trees. Map nodes merge recursively; declaration lists
  (keyword lists) merge by key with `override` winning.
  """
  def merge(base, override) when is_map(base) and is_map(override) do
    Map.merge(base, override, &merge_nodes/3)
  end

  def merge(base, _override), do: base

  @doc """
  Applies `:unset` keys inside declaration lists throughout the tree.
  """
  def apply_unset(tree) when is_map(tree) do
    Map.new(tree, fn {key, value} -> {key, apply_unset_node(value)} end)
  end

  def apply_unset(other), do: other

  @doc """
  Compiles a part tree for a component into `%Corex.Design.Rule{}` lists.
  """
  def compile_rules(component, tree, opts \\ []) when is_map(tree) do
    Compiler.compile(component, apply_unset(tree), opts)
  end

  @doc """
  Returns scoped plain CSS for a host element id (instance `style` attr).
  """
  def scoped_css(component, host_id, tree, opts \\ []) when is_binary(host_id) and is_map(tree) do
    scope = "#" <> host_id

    component
    |> compile_rules(tree, opts)
    |> Enum.map(fn %Corex.Design.Rule{selector: sel} = rule ->
      scoped = String.replace_prefix(sel, Compiler.host_selector(component), scope)
      %{rule | selector: scoped}
    end)
    |> Corex.Design.Emit.Css.rules_css()
  end

  @doc false
  def state_key?(key) when is_atom(key), do: key in @state_keys

  @doc false
  def reserved_key?(key) when is_atom(key), do: key in @reserved_keys

  @doc false
  def normalize_decls(decls) when is_list(decls) do
    {unset, decls} = Keyword.pop(decls, :unset, [])

    decls
    |> Keyword.reject(fn {key, _} -> key == :unset end)
    |> apply_unset_decls(unset)
    |> expand_decls()
  end

  def normalize_decls(%{} = decls), do: normalize_decls(Map.to_list(decls))

  defp merge_nodes(_key, left, right) when is_list(left) and is_list(right) do
    Keyword.merge(left, right)
  end

  defp merge_nodes(_key, left, right) when is_map(left) and is_map(right) do
    merge(left, right)
  end

  defp merge_nodes(_key, _left, right), do: right

  defp apply_unset_node(value) when is_map(value) do
    Map.new(value, fn {key, inner} -> {key, apply_unset_node(inner)} end)
  end

  defp apply_unset_node(value) when is_list(value), do: normalize_decls(value)

  defp apply_unset_node(value), do: value

  defp apply_unset_decls(decls, unset) do
    unset = List.wrap(unset)

    Enum.reject(decls, fn {key, _} ->
      key in unset or Atom.to_string(key) in Enum.map(unset, &to_string/1)
    end)
  end

  defp expand_decls(decls) do
    Enum.flat_map(decls, fn
      {:rotate, deg} when is_number(deg) ->
        [{:transform, "rotate(#{deg}deg)"}]

      {:rotate, deg} when is_binary(deg) ->
        [{:transform, "rotate(#{deg})"}]

      {:ring, width, color} ->
        [{:box_shadow, {:raw, "inset 0 0 0 #{width}px #{Corex.Design.Css.resolve_value(color)}"}}]

      other ->
        [other]
    end)
  end
end
defmodule Corex.Design.PartTree.Compiler do
  @moduledoc false

  alias Corex.Design.PartTree
  alias Corex.Design.PartTree.Accordion
  alias Corex.Design.Rule
  alias Corex.Design.Selector

  @pseudo %{
    hover: ":hover",
    focus: ":focus-visible",
    focus_visible: ":focus-visible",
    active: ":active"
  }

  def host_selector(:accordion), do: Selector.host(:accordion)

  def compile(component, tree, opts \\ [])

  def compile(:accordion, tree, opts) when is_map(tree) do
    host =
      case Keyword.get(opts, :host_id) do
        nil -> host_selector(:accordion)
        id -> "#" <> id
      end

    ctx = %{
      anatomy: Accordion,
      component: :accordion,
      host: host,
      recipe: Keyword.get(opts, :recipe, :accordion)
    }

    walk(tree, [], ctx, [])
  end

  def compile(component, _tree, _opts) do
    raise ArgumentError, "PartTree compile is not implemented for #{inspect(component)}"
  end

  defp walk(node, path, ctx, acc) when is_map(node) do
    Enum.reduce(node, acc, fn {key, value}, rules ->
      cond do
        key == :base and is_list(value) ->
          selector = part_selector(ctx, path)
          rule(selector, value, ctx) ++ rules

        pseudo_key?(key) and is_list(value) ->
          selector = pseudo_selector(ctx, path, key)
          rule(selector, value, ctx) ++ rules

        PartTree.state_key?(key) and is_list(value) ->
          selector = state_selector(ctx, path, key)
          rule(selector, value, ctx) ++ rules

        PartTree.state_key?(key) and is_map(value) ->
          walk(value, path, Map.put(ctx, :parent_state, {path, key}), rules)

        is_map(value) and part_child?(ctx, path, key) ->
          walk(value, path ++ [key], ctx, rules)

        true ->
          rules
      end
    end)
  end

  defp walk(_node, _path, _ctx, acc), do: acc

  defp part_child?(ctx, path, key) do
    key in ctx.anatomy.child_part_keys(normalize_path(path))
  end

  defp normalize_path([]), do: []
  defp normalize_path([:root | rest]), do: rest
  defp normalize_path(path), do: path

  defp part_selector(ctx, path) do
    case ctx.anatomy.part_selector(normalize_path(path)) do
      :host -> ctx.host <> " " <> Accordion.part_selector([:root])
      sel when is_binary(sel) -> ctx.host <> " " <> sel
    end
  end

  defp state_selector(ctx, path, state) do
    base = part_selector(ctx, path)

    case state do
      :base -> base
      s when s in [:open, :closed] -> base <> ~s([data-state="#{s}"])
    end
  end

  defp pseudo_selector(ctx, path, pseudo) do
    part_selector(ctx, path) <> Map.fetch!(@pseudo, pseudo)
  end

  defp pseudo_key?(key), do: Map.has_key?(@pseudo, key)

  defp rule(selector, decls, ctx) do
    if decls == [] do
      []
    else
      [Rule.new(selector, decls: normalize_rule_decls(decls, ctx))]
    end
  end

  defp normalize_rule_decls(decls, ctx) do
    decls
    |> PartTree.normalize_decls()
    |> Enum.map(fn
      {:include, _} = decl -> decl
      {:raw, _} = decl -> decl
      {prop, val} -> {prop, Corex.Design.Css.resolve_value(val, [recipe: ctx.recipe, selector: ""])}
    end)
  end
end
defmodule Corex.Design.PartTree.Vars do
  @moduledoc false

  alias Corex.Design.Css
  alias Corex.Design.PartTree
  alias Corex.Design.PartTree.Accordion
  alias Corex.Design.Rule

  @property_keys ~w(
    color background_color background text_underline_offset
    transform border_color outline box_shadow opacity text_decoration_line
  )a

  @shorthand_props %{
    text_decoration: :text_decoration_line
  }

  @doc """
  Converts a part-tree style map into host CSS custom properties for inline `style`.
  """
  def to_host_style(:accordion, tree) when is_map(tree) do
    prefix = Accordion.var_prefix()

    unset_vars = collect_unset_vars(tree, [], prefix, %{})

    set_vars =
      tree
      |> PartTree.apply_unset()
      |> collect_vars([], prefix, %{})

    unset_vars
    |> Map.merge(set_vars)
    |> Map.to_list()
    |> Enum.map(fn {name, value} -> {"--#{name}", value} end)
  end

  def to_host_style(_component, _tree), do: []

  @doc """
  Fallback rules that read host CSS variables set by `to_host_style/2`.
  """
  def fallback_rules(:accordion) do
    host = Corex.Design.PartTree.Compiler.host_selector(:accordion)
    trigger = Accordion.part_selector([:item, :trigger])
    indicator = Accordion.part_selector([:item, :indicator])
    prefix = Accordion.var_prefix()

    [
      Rule.new("#{host} #{trigger}[data-state=\"open\"]",
        decls: [
          {:raw, "color: var(--#{prefix}-item-trigger-open-color)"},
          {:raw, "background-color: var(--#{prefix}-item-trigger-open-background-color)"}
        ]
      ),
      Rule.new("#{host} #{trigger}:focus-visible",
        decls: [
          {:raw, "text-decoration-line: var(--#{prefix}-item-trigger-focus-text-decoration)"},
          {:raw, "text-underline-offset: var(--#{prefix}-item-trigger-focus-text-underline-offset)"},
          {:raw, "outline: var(--#{prefix}-item-trigger-focus-outline)"},
          {:raw, "box-shadow: var(--#{prefix}-item-trigger-focus-box-shadow)"}
        ]
      ),
      Rule.new("#{host} #{indicator}[data-state=\"open\"]",
        decls: [{:raw, "transform: var(--#{prefix}-item-indicator-open-transform)"}]
      )
    ]
  end

  def fallback_rules(_component), do: []

  defp collect_vars(node, path, prefix, acc) when is_map(node) do
    Enum.reduce(node, acc, fn {key, value}, vars ->
      cond do
        PartTree.state_key?(key) and is_list(value) ->
          vars
          |> Map.merge(decl_vars(path, key, value, prefix))

        pseudo_key?(key) and is_list(value) ->
          vars
          |> Map.merge(decl_vars(path, key, value, prefix))

        is_map(value) ->
          collect_vars(value, path ++ [key], prefix, vars)

        true ->
          vars
      end
    end)
  end

  defp collect_vars(_node, _path, _prefix, acc), do: acc

  defp collect_unset_vars(node, path, prefix, acc) when is_map(node) do
    Enum.reduce(node, acc, fn {key, value}, vars ->
      cond do
        (PartTree.state_key?(key) or pseudo_key?(key)) and is_list(value) ->
          vars |> Map.merge(unset_vars(path, key, value, prefix))

        is_map(value) ->
          collect_unset_vars(value, path ++ [key], prefix, vars)

        true ->
          vars
      end
    end)
  end

  defp collect_unset_vars(_node, _path, _prefix, acc), do: acc

  defp unset_vars(path, state, decls, prefix) do
    raw = if is_list(decls), do: decls, else: Map.to_list(decls)
    {unset, _} = Keyword.pop(raw, :unset, [])

    Enum.into(unset, %{}, fn prop ->
      key =
        case Map.fetch(@shorthand_props, prop) do
          {:ok, _} -> prop
          :error -> prop
        end

      {var_name(path, state, key, prefix), "initial"}
    end)
  end

  defp decl_vars(path, state, decls, prefix) do
    raw = if is_list(decls), do: decls, else: Map.to_list(decls)
    {unset, _} = Keyword.pop(raw, :unset, [])

    unset_vars =
      Enum.into(unset, %{}, fn prop ->
        {var_name(path, state, prop, prefix), "initial"}
      end)

    set_vars =
      raw
      |> PartTree.normalize_decls()
      |> Enum.reduce(%{}, fn {prop, val}, acc ->
        {resolve_prop, var_key} =
          case Map.fetch(@shorthand_props, prop) do
            {:ok, canonical} -> {canonical, prop}
            :error -> {prop, prop}
          end

        if resolve_prop in @property_keys do
          css_val = Css.resolve(resolve_prop, val, recipe: :accordion, selector: "")
          Map.put(acc, var_name(path, state, var_key, prefix), css_val)
        else
          acc
        end
      end)

    Map.merge(unset_vars, set_vars)
  end

  defp var_name(path, state, prop, prefix) do
    slug = path_slug(path) <> "-" <> Atom.to_string(state)
    prop_slug = prop |> Atom.to_string() |> String.replace("_", "-")
    "#{prefix}-#{slug}-#{prop_slug}"
  end

  defp path_slug([]), do: "host"

  defp path_slug(path) do
    path |> Enum.map_join("-", &Atom.to_string/1)
  end

  defp pseudo_key?(key) when is_atom(key), do: key in ~w(hover focus focus_visible active)a
end
defmodule Corex.Design.PartTree.Accordion do
  @moduledoc false

  alias Corex.Design.Selector

  @scope "accordion"

  @child_parts %{
    item: [:trigger, :content, :indicator],
    trigger: [:text, :indicator],
    content: [:p]
  }

  @part_names %{
    root: "root",
    item: "item",
    trigger: "item-trigger",
    content: "item-content",
    text: "item-text",
    indicator: "item-indicator",
    p: "p"
  }

  def var_prefix, do: "corex-accordion"

  def component, do: :accordion

  def part_selector(path) do
    case path_to_part(path) do
      {:slot, name} ->
        slot(name)

      {:content_p, _} ->
        ~s(#{slot("item-content")} > p)

      :host ->
        slot("root")
    end
  end

  def child_part_keys(path) do
    case List.last(path) do
      nil -> [:root, :item]
      part -> Map.get(@child_parts, part, [])
    end
  end

  def part_path?(path) do
    path_to_part(path) != :error
  end

  defp slot(name), do: Selector.slot(@scope, name)


  defp path_to_part([]), do: :host

  defp path_to_part([:root]), do: {:slot, @part_names.root}

  defp path_to_part([:item]), do: {:slot, @part_names.item}

  defp path_to_part([:item, :trigger]), do: {:slot, @part_names.trigger}

  defp path_to_part([:item, :content]), do: {:slot, @part_names.content}

  defp path_to_part([:item, :trigger, :indicator]), do: {:slot, @part_names.indicator}

  defp path_to_part([:item, :indicator]), do: {:slot, @part_names.indicator}

  defp path_to_part([:item, :trigger, :text]), do: {:slot, @part_names.text}

  defp path_to_part([:item, :content, :p]), do: {:content_p, @part_names.p}

  defp path_to_part(_), do: :error
end
