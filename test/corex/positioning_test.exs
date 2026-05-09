defmodule Corex.PositioningTest do
  use ExUnit.Case, async: true

  describe "to_dataset/1" do
    test "emits flat data-position keys for a struct" do
      p = %Corex.Positioning{placement: "top-start", gutter: 12}
      m = Corex.Positioning.to_dataset(p)

      assert m["data-position-placement"] == "top-start"
      assert m["data-position-gutter"] == "12"
    end

    test "emits offset axis keys when set" do
      p = %Corex.Positioning{
        offset: %Corex.Offset{main_axis: 1, cross_axis: 2}
      }

      m = Corex.Positioning.to_dataset(p)

      assert m["data-position-offset-main-axis"] == "1"
      assert m["data-position-offset-cross-axis"] == "2"
    end

    test "empty map for nil" do
      assert Corex.Positioning.to_dataset(nil) == %{}
    end
  end
end
