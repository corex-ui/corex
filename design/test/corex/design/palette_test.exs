defmodule Corex.Design.PaletteTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Palette

  test "scale token helpers map roles to --color-* names" do
    assert Palette.fg_var(:accent) == "--color-accent"
    assert Palette.solid_var(:accent) == "--color-accent"
    assert Palette.on_solid_var(:accent) == "--color-on-accent"
    assert Palette.fg_var(:base) == "--color-on-base"
    assert Palette.fg_var(:implicit) == "--color-on-base"
    assert Palette.solid_var(:base) == "--color-base"
    assert Palette.solid_var(:implicit) == "--color-base"
  end

  test "on-solid and ink token names follow background-ink contrast pattern" do
    assert Palette.ink_color_var(:accent) == "--color-accent"
    assert Palette.on_solid_color_var(:accent) == "--color-on-accent"
    assert Palette.on_solid_color_var(:base) == "--color-on-base"
  end
end
