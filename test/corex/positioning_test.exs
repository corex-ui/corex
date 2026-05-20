defmodule Corex.PositioningTest do
  use ExUnit.Case, async: true

  alias Corex.Positioning

  test "to_dataset/1 nil" do
    assert Positioning.to_dataset(nil) == %{}
  end

  test "to_dataset/1 encodes flip list and offset axes" do
    dataset =
      Positioning.to_dataset(%Positioning{
        flip: ["top", "bottom"],
        offset: %Corex.Offset{main_axis: 4, cross_axis: -2}
      })

    assert dataset["data-position-flip"] == "top,bottom"
    assert dataset["data-position-offset-main-axis"] == "4"
    assert dataset["data-position-offset-cross-axis"] == "-2"
  end

  test "to_dataset/1 omits invalid flip and bool values" do
    dataset = Positioning.to_dataset(%Positioning{flip: :invalid, slide: :invalid})

    assert dataset["data-position-flip"] == nil
    assert dataset["data-position-slide"] == nil
  end
end
