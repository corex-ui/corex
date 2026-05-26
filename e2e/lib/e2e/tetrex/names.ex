defmodule E2e.Tetrex.Names do
  @moduledoc false

  @words [
    "Nova",
    "Brick",
    "Swift",
    "Pixel",
    "Storm",
    "Blaze",
    "Frost",
    "Echo",
    "Volt",
    "Drift",
    "Prism",
    "Rune",
    "Comet",
    "Flare",
    "Glyph",
    "Spark",
    "Titan",
    "Zest",
    "Quartz",
    "Nimbus",
    "Orbit",
    "Pulse",
    "Ridge",
    "Slate",
    "Vivid",
    "Wisp",
    "Apex",
    "Bolt",
    "Crest",
    "Dusk",
    "Ember",
    "Glint",
    "Haze",
    "Ion",
    "Jade",
    "Kite",
    "Lumen",
    "Mist",
    "Onyx",
    "Plume",
    "Quest",
    "Rust",
    "Surge",
    "Tide",
    "Umber",
    "Vex",
    "Warp"
  ]

  def random do
    Enum.random(@words)
  end

  def display(nil), do: random()
  def display(""), do: random()
  def display(name) when is_binary(name), do: name
  def display(_), do: random()
end
