defmodule Corex.Design.PaletteTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Palette

  test "scale token helpers map roles to --color-* names" do
    assert Palette.fg_var(:accent) == "--color-ui-ink-accent"
    assert Palette.solid_var(:accent) == "--color-accent"
    assert Palette.on_solid_var(:accent) == "--color-accent-ink"
    assert Palette.fg_var(:selected) == "--color-selected-ink"
    assert Palette.solid_var(:neutral) == "--color-ui"
  end

  test "on-solid and ink token names follow background-ink contrast pattern" do
    assert Palette.ink_color_var(:accent) == "--color-ui-ink-accent"
    assert Palette.on_solid_color_var(:accent) == "--color-accent-ink"
    assert Palette.on_solid_color_var(:selected) == "--color-selected-ink"
  end
end
