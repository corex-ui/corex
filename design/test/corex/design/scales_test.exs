defmodule Corex.Design.ScalesTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Scales
  alias Corex.StyleAxes

  test "attr_values uses built-in step names" do
    assert "md" in Scales.attr_values(:size)
    assert "bogus" not in Scales.attr_values(:size)
  end

  test "dimension_steps always returns built-in steps" do
    assert Scales.dimension_steps(:size) == StyleAxes.builtin_step_strings(:size)
  end
end
