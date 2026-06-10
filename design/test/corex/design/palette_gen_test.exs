defmodule Corex.Design.PaletteGenTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Tokens.Colors
  alias Corex.Design.Tokens.PaletteGen

  test "at_lightness returns hex near target OKLCH lightness" do
    {hex, _cache} = PaletteGen.at_lightness("#F0F0F0", 94)
    assert String.match?(hex, ~r/^#[0-9A-Fa-f]{6}$/)

    {:ok, color} = Color.new(hex)
    {:ok, okl} = Color.convert(color, Color.Oklch)
    assert_in_delta okl.l, 0.94, 0.04
  end

  test "tonal scale is in sRGB gamut for preset palette anchors" do
    for seed <- ["#F0F0F0", "#32479C", "#4B4B4B", "#059669"] do
      assert PaletteGen.in_gamut?(seed)
    end
  end

  test "normalize_lightness! rejects out of range values" do
    assert_raise ArgumentError, ~r/invalid lightness/, fn ->
      PaletteGen.normalize_lightness!(123)
    end
  end

  test "contrast_fg hits the requested ratio within tolerance" do
    {hex, achieved} = PaletteGen.contrast_fg("#32479C", "#F0F0F0", 7.0)
    assert is_binary(hex)
    assert achieved >= 6.9
  end

  test "on tokens meet configured contrast against their fill" do
    colors = Colors.generate()
    brand = colors[{:neo, :light}]["brand"]
    on_brand = colors[{:neo, :light}]["on-brand"]

    {:ok, a} = Color.new(brand)
    {:ok, b} = Color.new(on_brand)
    ratio = Color.Contrast.wcag_ratio(a, b)
    assert ratio >= 6.9
  end

  test "default on-page meets configured contrast against page surface" do
    colors = Colors.generate()
    on_page = colors[{:neo, :light}]["on-page"]
    page = colors[{:neo, :light}]["surface-page"]

    {:ok, ink_c} = Color.new(on_page)
    {:ok, surface_c} = Color.new(page)
    ratio = Color.Contrast.wcag_ratio(ink_c, surface_c)
    assert ratio >= 7.9
  end

  test "neo light border is subtler than a 1.3 ratio target against control surface" do
    colors = Colors.generate()
    border = colors[{:neo, :light}]["border"]
    control = colors[{:neo, :light}]["surface-control"]

    {:ok, border_c} = Color.new(border)
    {:ok, control_c} = Color.new(control)
    ratio = Color.Contrast.wcag_ratio(border_c, control_c)

    assert ratio >= 1.1
    assert ratio < 1.25
  end
end
