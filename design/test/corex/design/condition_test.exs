defmodule Corex.Design.ConditionTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Condition

  test "condition?/1 recognizes pseudo and zag atoms" do
    assert Condition.condition?(:hover)
    assert Condition.condition?(:visited)
    assert Condition.condition?(:invalid)
    assert Condition.condition?(:open)
    refute Condition.condition?(:display)
  end

  test "selector/1 maps atoms to nested selectors" do
    assert Condition.selector(:hover) == "&:hover"
    assert Condition.selector(:visited) == "&:visited"
    assert Condition.selector(:invalid) == "&[data-invalid]"
    assert Condition.selector(:selected) =~ "data-state=\"checked\""
  end

  test "selector/1 joins compound condition lists" do
    assert Condition.selector([:invalid, :focus_visible]) =~ "&[data-invalid]"
    assert Condition.selector([:invalid, :focus_visible]) =~ "focus-visible"
  end

  test "selector/1 supports at-rule tuples" do
    assert Condition.selector({:at, "@media print"}) == "@media print"
  end
end
