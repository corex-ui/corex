defmodule Corex.Design.ExportParityTest do
  @moduledoc """
  Guards Tailwind export shape: prefixed `@utility` wildcards, explicit BEM in
  `@layer components`, and class file size budgets.
  """
  use ExUnit.Case, async: true

  alias Corex.Design.Recipe
  alias Corex.Design.Recipes
  alias Corex.Design.Selector

  test "tailwind exports avoid main modifier utility wildcards" do
    for recipe <- Recipes.all() do
      css = Recipe.to_css(recipe)
      name = Selector.class_name(recipe.id)
      refute css =~ "@utility #{name}--*"
    end
  end

  test "tailwind class exports stay within line budgets" do
    budgets = %{
      accordion: 2150,
      select: 1200,
      button: 1200,
      tree_view: 2720
    }

    for {id, max_lines} <- budgets do
      recipe = Enum.find(Recipes.all(), &(&1.id == id))
      css = Recipe.to_css(recipe)
      lines = css |> String.split("\n") |> length()

      assert lines <= max_lines,
             "expected #{id} tailwind export <= #{max_lines} lines, got #{lines}"
    end
  end

  test "layout recipes emit functional utilities for scale axes" do
    expectations = %{
      stack: "@utility stack--padding-*",
      row: "@utility row--padding-*",
      grid: "@utility grid--gap-*"
    }

    for {id, utility} <- expectations do
      recipe = Enum.find(Recipes.all(), &(&1.id == id))
      css = Recipe.to_css(recipe)

      refute css =~ "@utility #{id}--*"
      assert css =~ utility
      assert css =~ "@layer components"
      assert css =~ ".#{id} {"
    end
  end

  test "accordion tailwind export uses apply, prefixed utilities, and bem semantics" do
    css =
      Recipes.all()
      |> Enum.find(&(&1.id == :accordion))
      |> Recipe.to_css()

    assert css =~ "@apply part-trigger"
    assert css =~ "@utility accordion--rounded-*"
    assert css =~ "@utility accordion--text-*"
    assert css =~ "@utility accordion--max-w-*"
    assert css =~ "@utility accordion--size-*"
    assert css =~ ".accordion.accordion--w-fit"
    assert css =~ ".accordion.accordion--semantic-accent"
    assert css =~ ".accordion.accordion--semantic-base"
    assert css =~ ".accordion.accordion--variant-subtle"
    assert css =~ "[data-state=\"closed\"]"
    assert css =~ "background-color: var(--color-accent)"
    assert css =~ "color: var(--color-on-accent)"
    refute css =~ "@utility accordion--*"
    refute css =~ ".accordion.accordion--max-w-7xs"
    refute css =~ ".accordion.accordion--size-md [data-part"
    refute css =~ "semantic-neutral"
    refute css =~ "semantic-selected"
    refute css =~ "--color-neutral"
    refute css =~ "--color-selected"

    assert css =~ "@utility accordion--size-*"
    refute css =~ ~r/accordion--size-\* \{[\s\S]*item-trigger\][\s\S]*font-size:/
  end
end
