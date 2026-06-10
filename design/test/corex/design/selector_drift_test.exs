defmodule Corex.Design.SelectorDriftTest do
  use ExUnit.Case, async: true

  alias Corex.Bem
  alias Corex.Design.Bem, as: DesignBem
  alias Corex.Design.Recipes
  alias Corex.Design.Rule

  @legacy_semantic ~r/\.[a-z][a-z0-9-]*\.[a-z][a-z0-9-]*--(accent|brand|alert|info|success|muted|neutral)(?![a-z0-9-])/
  @legacy_size ~r/\.[a-z][a-z0-9-]*\.[a-z][a-z0-9-]*--(sm|md|lg|xl|2xl)(?![a-z0-9-])/

  test "Corex.Bem.step matches design host selectors for standard axes" do
    assert Bem.step(:semantic, "accent") == "semantic-accent"
    assert Bem.step(:size, "md") == "size-md"
    assert Bem.step(:variant, "solid") == "variant-solid"
    assert Bem.step(:radius, "lg") == "rounded-lg"

    assert DesignBem.host_selector(:button, :semantic, :accent) ==
             ".button.button--semantic-accent"

    assert DesignBem.host_selector(:clipboard, :size, :sm) == ".clipboard.clipboard--size-sm"
  end

  test "recipe extra_rules selectors do not use unprefixed semantic or size host modifiers" do
    offenders =
      for recipe <- Recipes.components(),
          selector <- rule_selectors(recipe.extra_rules || []),
          drift = legacy_drift(selector),
          not is_nil(drift) do
        {recipe.id, selector, drift}
      end

    assert offenders == [],
           "unprefixed host modifiers in extra_rules:\n#{format_offenders(offenders)}"
  end

  defp rule_selectors(rules) when is_list(rules) do
    Enum.flat_map(rules, &collect_selectors/1)
  end

  defp collect_selectors(%Rule{selector: selector, children: children}) do
    [selector | Enum.flat_map(children || [], &collect_selectors/1)]
  end

  defp collect_selectors(_), do: []

  defp legacy_drift(selector) when is_binary(selector) do
    cond do
      Regex.match?(@legacy_semantic, selector) -> :semantic
      Regex.match?(@legacy_size, selector) -> :size
      true -> nil
    end
  end

  defp legacy_drift(_), do: nil

  defp format_offenders(offenders) do
    offenders
    |> Enum.map_join("\n", fn {id, selector, drift} ->
      "  #{id} (#{drift}): #{String.slice(selector, 0, 120)}"
    end)
  end
end
