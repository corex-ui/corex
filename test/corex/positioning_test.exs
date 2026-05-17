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

    test "encodes flip list and boolean options" do
      p = %Corex.Positioning{
        flip: ["top", "bottom"],
        slide: false,
        overlap: true,
        same_width: true,
        fit_viewport: false,
        hide_when_detached: false
      }

      m = Corex.Positioning.to_dataset(p)

      assert m["data-position-flip"] == "top,bottom"
      assert m["data-position-slide"] == "false"
      assert m["data-position-overlap"] == "true"
      assert m["data-position-same-width"] == "true"
      assert m["data-position-fit-viewport"] == "false"
      assert m["data-position-hide-when-detached"] == "false"
    end
  end
end
