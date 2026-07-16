defmodule Corex.MarqueeAnatomyTest do
  use ExUnit.Case, async: true

  alias Corex.Marquee.Anatomy

  test "Props struct defaults" do
    props = %Anatomy.Props{id: "m", duration: 10.0}

    assert props.side == "end"
    assert props.speed == 50
    assert props.auto_fill == true
    assert props.respect_reduced_motion == true
    assert Anatomy.Props.ignored_attrs() == ["data-loading"]
  end

  test "Root Edge Viewport Content and Item structs" do
    assert %Anatomy.Root{id: "m", duration: 1.0, orientation: "horizontal"}.paused == false

    assert %Anatomy.Edge{side: "start", orientation: "horizontal"}.side == "start"

    assert %Anatomy.Viewport{id: "m", orientation: "vertical", side: "top"}.id == "m"

    assert %Anatomy.Content{
             root_id: "m",
             index: 0,
             orientation: "horizontal",
             side: "end",
             reverse: false
           }.index == 0

    assert %Anatomy.Item{orientation: "vertical"}.orientation == "vertical"
  end
end
