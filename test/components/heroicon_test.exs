defmodule Corex.HeroiconTest do
  use CorexTest.ComponentCase

  alias Corex.Heroicon

  test "renders heroicon" do
    html = render_component(&Heroicon.heroicon/1, name: "hero-x-mark")
    assert html =~ "span"
    assert html =~ "hero-x-mark"
  end

  test "renders heroicon with custom class" do
    html = render_component(&Heroicon.heroicon/1, name: "hero-arrow-path", class: "custom-class")
    assert html =~ "span"
    assert html =~ "hero-arrow-path"
    assert html =~ "custom-class"
  end
end