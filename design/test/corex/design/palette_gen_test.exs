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

  test "tonal scale is in sRGB gamut for preset seeds" do
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

  test "semantic ink meets configured contrast against its fill" do
    colors = Colors.generate()
    brand = colors[{:neo, :light}]["brand"]
    ink = colors[{:neo, :light}]["brand-ink"]

    {:ok, a} = Color.new(brand)
    {:ok, b} = Color.new(ink)
    ratio = Color.Contrast.wcag_ratio(a, b)
    assert ratio >= 6.9
  end

  test "default ui ink meets configured contrast against ink reference surface" do
    colors = Colors.generate()
    ink = colors[{:neo, :light}]["ui-ink"]

    {:ok, ink_c} = Color.new(ink)
    {:ok, ui_muted} = Color.new(colors[{:neo, :light}]["ui-muted"])
    ratio = Color.Contrast.wcag_ratio(ink_c, ui_muted)
    assert ratio >= 7.9
  end

  test "neo light border is subtler than a 1.3 ratio target against ui" do
    colors = Colors.generate()
    border = colors[{:neo, :light}]["border"]
    ui = colors[{:neo, :light}]["ui"]

    {:ok, border_c} = Color.new(border)
    {:ok, ui_c} = Color.new(ui)
    ratio = Color.Contrast.wcag_ratio(border_c, ui_c)

    assert ratio >= 1.1
    assert ratio < 1.25
  end
end
