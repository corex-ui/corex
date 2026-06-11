defmodule Corex.Design.CssTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Css

  test "resolve/3 maps space steps to vars" do
    assert Css.resolve(:gap, :md) == "var(--spacing-md)"
  end

  test "resolve/3 passes CSS keywords for color properties" do
    assert Css.resolve(:background_color, :transparent) == "transparent"
  end

  test "resolve/3 validates unknown properties" do
    assert_raise ArgumentError, ~r/unknown property/, fn ->
      Css.resolve(:not_a_property, :md)
    end
  end

  test "resolve_property_value/2 maps ring to box-shadow" do
    {prop, value} = Css.resolve_property_value({:ring, 2})
    assert prop == "box-shadow"
    assert value =~ "2px"
  end

  test "resolve/3 accepts raw tuples on enum properties" do
    assert Css.resolve(:pointer_events, {:raw, "none !important"}) == "none !important"
  end

  test "resolve/3 maps custom property color refs to var()" do
    assert Css.resolve(:"--color-base", {:color, :accent}) == "var(--color-accent)"
    assert Css.resolve(:"--color-base-ink", {:color, :brand_ink}) == "var(--color-brand)"
  end
end
