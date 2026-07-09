defmodule E2eWeb.TailwindSizingLiteralsTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Scales
  alias E2eWeb.TailwindSizingLiterals

  test "literal lists cover every Scales step for each sizing axis" do
    assert length(TailwindSizingLiterals.max_width_literals()) ==
             length(Scales.steps(:max_width))

    assert length(TailwindSizingLiterals.min_width_literals()) ==
             length(Scales.steps(:min_width))

    assert length(TailwindSizingLiterals.width_literals()) == length(Scales.steps(:width))

    assert length(TailwindSizingLiterals.max_height_literals()) ==
             length(Scales.steps(:max_height))

    assert length(TailwindSizingLiterals.min_height_literals()) ==
             length(Scales.steps(:min_height))
  end

  test "lookup maps return static class strings for extended steps" do
    assert TailwindSizingLiterals.max_width("9xs") == "max-w-9xs"
    assert TailwindSizingLiterals.max_width("5xs") == "max-w-5xs"
    assert TailwindSizingLiterals.max_width("8xl") == "max-w-8xl"
    assert TailwindSizingLiterals.width("6xs") == "w-6xs"
    assert TailwindSizingLiterals.max_height("9xl") == "max-h-9xl"
  end
end
