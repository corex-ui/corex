defmodule Corex.Design.Emit.Css do
  @moduledoc false

  alias Corex.Design.Emit.RuleRenderer

  def rules_css(rules) when is_list(rules) do
    RuleRenderer.rules_css(rules, &expand/1)
  end

  def rule_css(rule, level \\ 0), do: RuleRenderer.rule_css(rule, level, &expand/1)

  defp expand(rule) do
    RuleRenderer.expand_includes(rule, &RuleRenderer.inline_include/3)
  end
end
