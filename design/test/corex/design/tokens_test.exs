defmodule Corex.Design.TokensTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Theme
  alias Corex.Design.Tokens.Scales

  describe "in_ladder_order/2" do
    test "orders steps by the ladder rather than by map iteration" do
      values = %{xl: 4, xs: 1, md: 3, sm: 2}

      assert Scales.in_ladder_order(values, ~w(xs sm md lg xl)a) ==
               [xs: 1, sm: 2, md: 3, xl: 4]
    end

    test "keeps steps outside the ladder after it, sorted by name" do
      values = %{md: 1, zeta: 2, alpha: 3}

      assert Scales.in_ladder_order(values, ~w(md)a) == [md: 1, alpha: 3, zeta: 2]
    end

    test "returns an empty list for no values" do
      assert Scales.in_ladder_order(%{}, ~w(xs sm)a) == []
    end
  end

  describe "resolved scales" do
    test "emit radius in ladder order, not atom table order" do
      steps = Enum.map(Theme.radius(:uno), &elem(&1, 0))

      assert steps == Keyword.keys(Scales.builtin_radius())
    end

    test "emit text sizes in ladder order" do
      steps = Enum.map(Theme.text(:uno), &elem(&1, 0))

      assert steps == Keyword.keys(Scales.builtin_text())
    end

    test "emit font weights in ladder order" do
      assert Keyword.keys(Scales.weight()) == Keyword.keys(Scales.builtin_weight())
    end

    test "emit font stacks in ladder order even when a theme overrides one" do
      assert Keyword.keys(Corex.Design.Emit.Tokens.font_stacks_for(:uno)) ==
               Keyword.keys(Scales.font())
    end
  end
end
