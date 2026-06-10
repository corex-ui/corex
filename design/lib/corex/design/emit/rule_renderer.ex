defmodule Corex.Design.Emit.RuleRenderer do
  @moduledoc false

  alias Corex.Design.Css
  alias Corex.Design.Fragment
  alias Corex.Design.Rule

  @indent "  "

  def rules_css(rules, expand) when is_function(expand, 1) do
    rules
    |> Enum.map(&rule_css(&1, 0, expand))
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  def rule_css(%Rule{selector: selector} = rule, level, expand) do
    {decls, children} = expand.(rule)

    inner =
      [decl_lines(decls, level + 1, expand), child_blocks(children, level + 1, expand)]
      |> Enum.reject(&(&1 == ""))
      |> Enum.join("\n")

    pad = String.duplicate(@indent, level)

    if inner == "" do
      ""
    else
      "#{pad}#{selector} {\n#{inner}\n#{pad}}"
    end
  end

  defp decl_lines([], _level, _expand), do: ""

  defp decl_lines(decls, level, expand) do
    pad = String.duplicate(@indent, level)

    decls
    |> Enum.map_join("\n", fn decl -> pad <> decl_line(decl, expand) end)
  end

  defp decl_line({:raw, css}, _expand) when is_binary(css), do: css
  defp decl_line({:apply, name}, _expand), do: "@apply #{name};"

  defp decl_line({property, value}, _expand) do
    {css_prop, css_val} = Css.resolve_property_value({property, value})
    "#{css_prop}: #{css_val};"
  end

  defp child_blocks([], _level, _expand), do: ""

  defp child_blocks(children, level, expand) do
    children
    |> Enum.map(&rule_css(&1, level, expand))
    |> Enum.reject(&(&1 == ""))
    |> Enum.join("\n\n")
  end

  def expand_includes(%Rule{decls: decls, children: children}, include_handler) do
    Enum.reduce(decls, {[], children}, fn
      {:include, fragment}, {acc_decls, acc_children} ->
        include_handler.(fragment, acc_decls, acc_children)

      decl, {acc_decls, acc_children} ->
        {acc_decls ++ [decl], acc_children}
    end)
  end

  def inline_include(fragment, acc_decls, acc_children) do
    %{decls: frag_decls, children: frag_children} = Fragment.get!(fragment)
    {acc_decls ++ frag_decls, acc_children ++ frag_children}
  end

  def apply_include(fragment, acc_decls, acc_children) do
    name = Fragment.utility_name(fragment)
    {acc_decls ++ [{:apply, name}], acc_children}
  end
end
