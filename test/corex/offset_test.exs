defmodule Corex.OffsetTest do
  use ExUnit.Case, async: true

  alias Corex.Offset

  test "defaults" do
    assert %Offset{} == %Offset{main_axis: nil, cross_axis: nil}
  end

  test "custom axes" do
    assert %Offset{main_axis: 4, cross_axis: -2}.main_axis == 4
  end

  test "module exposes struct" do
    assert %{main_axis: nil, cross_axis: nil} = struct(Offset)
  end

  test "serializes through Positioning.to_dataset/1" do
    positioning = %Corex.Positioning{
      placement: "bottom",
      offset: %Offset{main_axis: 8, cross_axis: -4}
    }

    dataset = Corex.Positioning.to_dataset(positioning)

    assert dataset["data-position-offset-main-axis"] == "8"
    assert dataset["data-position-offset-cross-axis"] == "-4"
  end
end
