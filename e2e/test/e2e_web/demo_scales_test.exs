defmodule E2eWeb.DemoScalesTest do
  use ExUnit.Case, async: true

  alias Corex.Design.Scales
  alias E2eWeb.DemoScales

  @master_ladder [
    "9xs",
    "8xs",
    "7xs",
    "6xs",
    "5xs",
    "4xs",
    "3xs",
    "2xs",
    "xs",
    "sm",
    "md",
    "lg",
    "xl",
    "2xl",
    "3xl",
    "4xl",
    "5xl",
    "6xl",
    "7xl",
    "8xl",
    "9xl"
  ]

  test "demo scales mirror Corex.Design.Scales for documented axes" do
    assert DemoScales.max_width_steps() == Scales.steps(:max_width)
    assert DemoScales.min_width_steps() == Scales.steps(:min_width)
    assert DemoScales.width_steps() == Scales.steps(:width)
    assert DemoScales.max_height_steps() == Scales.steps(:max_height)
    assert DemoScales.min_height_steps() == Scales.steps(:min_height)
    assert DemoScales.radius_steps() == Scales.steps(:radius)
    assert DemoScales.size_steps() == Scales.steps(:size)
    assert DemoScales.text_steps() == Scales.steps(:text)
    assert DemoScales.semantic_steps() == Scales.semantic_steps()
  end

  test "max_width steps follow full master ladder with none and full" do
    assert DemoScales.max_width_steps() == ["none", "full" | @master_ladder]
  end

  test "width steps include auto, full, fit and master ladder" do
    assert DemoScales.width_steps() == ["auto", "full", "fit" | @master_ladder]
  end

  test "tailwind utility builders use static literal class strings" do
    assert DemoScales.tailwind_max_width("md") == "max-w-md"
    assert DemoScales.tailwind_max_width("9xs") == "max-w-9xs"
    assert DemoScales.tailwind_max_width("5xs") == "max-w-5xs"
    assert DemoScales.tailwind_width("md") == "w-md"
    assert DemoScales.tailwind_width("6xs") == "w-6xs"
    assert DemoScales.tailwind_max_width("none") == "max-w-none"
  end

  test "styling_variant_axis_steps is subtle default plus ui-solid only" do
    steps = DemoScales.styling_variant_axis_steps("button")

    assert Enum.map(steps, & &1.modifier) == ["", "ui-solid"]
    assert Enum.map(steps, & &1.label) == ["Subtle (default)", "Solid"]
  end

  test "join_block_modifiers prepends w-full for fit max-width demos" do
    assert DemoScales.join_block_modifiers("button", "max-w-md") ==
             "button w-full max-w-md"

    assert DemoScales.join_block_modifiers("button", "") == "button w-full"
  end

  test "width_layout_variants exposes default, w-full, and w-fit only" do
    variants = DemoScales.width_layout_variants("button")

    assert length(variants) == 3
    assert Enum.map(variants, & &1.modifier) == ["", "w-full", "w-fit"]
    assert Enum.map(variants, & &1.id) == ["default", "full", "fit"]
  end

  test "width_layout_options_for includes intrinsic default label" do
    assert DemoScales.width_layout_options_for("button") ==
             [
               "default (#{DemoScales.default_width_label("button")})",
               "full",
               "fit"
             ]
  end
end
