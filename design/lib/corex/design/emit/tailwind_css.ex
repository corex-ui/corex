defmodule Corex.Design.Emit.TailwindCss do
  @moduledoc false

  alias Corex.Design.Emit.RuleRenderer
  alias Corex.Design.Fragment
  alias Corex.Design.Rule

  def rules_css(rules) when is_list(rules) do
    RuleRenderer.rules_css(rules, &expand/1)
  end

  def rule_css(rule, level \\ 0) do
    RuleRenderer.rule_css(rule, level, &expand/1)
  end

  def fragment_utility_body(id) do
    %{decls: decls, children: children} = Fragment.get!(id)
    rule = %Rule{selector: "&", decls: decls, children: children}
    rule_css(rule, 0) |> String.trim_leading()
  end

  defp expand(rule) do
    RuleRenderer.expand_includes(rule, &RuleRenderer.apply_include/3)
  end
end
