defmodule Corex.Design.Style do
  @moduledoc false

  alias Corex.Design.Condition
  alias Corex.Design.Css

  @indent "  "

  @doc """
  Renders an sx map to nested CSS under `selector`.
  """
  @breakpoint_keys [:sm, :md, :lg, :xl, :"2xl"]

  def to_css(selector, sx, context \\ []) when is_binary(selector) and is_map(sx) do
    {conditions, props} = sx |> expand_responsive_values() |> partition()
    decl_lines = decl_lines(props, context)

    cond_blocks =
      conditions
      |> Enum.map(fn {cond, nested} ->
        cond_selector = Condition.selector(cond)
        nested_css = to_css(cond_selector, nested, context)
        indent_block(nested_css, 1)
      end)
      |> Enum.reject(&(&1 == ""))

    inner =
      [decl_lines | cond_blocks]
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("\n")

    if inner == "" do
      ""
    else
      "#{selector} {\n#{inner}\n}"
    end
  end

  @doc """
  Merges sx maps left-to-right; nested condition maps deep-merge.
  """
  def merge(left, right, more) when is_map(more), do: merge(merge(left, right), more)

  def merge(left, right) when is_map(left) and is_map(right) do
    Map.merge(left, right, &merge_values/3)
  end

  def merge_many(maps) when is_list(maps) do
    Enum.reduce(maps, %{}, &merge(&2, &1))
  end

  defp merge_values(_k, v1, v2) when is_map(v1) and is_map(v2) do
    if condition_map?(v1) or condition_map?(v2) do
      merge(v1, v2)
    else
      v2
    end
  end

  defp merge_values(_k, _v1, v2), do: v2

  @doc false
  def responsive_value?(val) when is_map(val) do
    keys = Map.keys(val)
    keys != [] and Enum.all?(keys, &(&1 in [:base | @breakpoint_keys]))
  end

  def responsive_value?(_), do: false

  # Lifts value-level responsive maps (`gap: %{base: "sm", md: "lg"}`) into the
  # block-level breakpoint condition maps (`%{gap: "sm", md: %{gap: "lg"}}`) so
  # the existing condition/`@media` nesting renders them. Works for both exports.
  defp expand_responsive_values(sx) do
    {plain, contributions} =
      Enum.reduce(sx, {%{}, []}, fn {key, val}, {plain, contribs} ->
        if is_atom(key) and not Condition.condition?(key) and responsive_value?(val) do
          base = Map.get(val, :base, :__none__)
          plain = if base == :__none__, do: plain, else: Map.put(plain, key, base)
          contribs = contribs ++ for {bp, v} <- val, bp in @breakpoint_keys, do: {bp, {key, v}}
          {plain, contribs}
        else
          {Map.put(plain, key, val), contribs}
        end
      end)

    Enum.reduce(contributions, plain, fn {bp, {key, v}}, acc ->
      Map.update(acc, bp, %{key => v}, fn existing ->
        if is_map(existing), do: Map.put(existing, key, v), else: existing
      end)
    end)
  end

  defp partition(sx) do
    Enum.split_with(sx, fn
      {key, _} when is_list(key) -> true
      {key, val} when is_atom(key) -> Condition.condition?(key) or at_rule?(key, val)
      _ -> false
    end)
  end

  defp at_rule?({:at, _rule}, _val), do: true
  defp at_rule?(key, %{}) when key in [:sm, :md, :lg, :xl, :"2xl"], do: true
  defp at_rule?(_key, _val), do: false

  defp condition_map?(map) do
    Enum.any?(map, fn {k, _} -> Condition.condition?(k) or is_list(k) end)
  end

  defp decl_lines(props, context) do
    Enum.map_join(props, "\n", fn {prop, value} ->
      {css_prop, css_value} = Css.resolve_property_value({prop, value}, context)
      "  #{css_prop}: #{css_value};"
    end)
  end

  defp indent_block(css, level) when is_binary(css) do
    pad = String.duplicate(@indent, level)

    css
    |> String.split("\n")
    |> Enum.map_join("\n", fn
      "" -> ""
      line -> pad <> line
    end)
  end
end
