defmodule Corex.AnimationTest do
  use ExUnit.Case, async: true

  alias Corex.Animation.Height
  alias Corex.Animation.Scale

  test "namespace module loads" do
    for mod <- [Corex.Animation, Height, Scale] do
      assert {:module, _} = Code.ensure_loaded(mod)
    end
  end

  describe "Height.to_dataset/1" do
    test "default options" do
      dataset = Height.to_dataset(%Height{})

      assert dataset["data-anim-height-duration"] == 0.3
      assert dataset["data-anim-height-easing"] == "ease"
      assert dataset["data-anim-height-opacity-start"] == 0.0
      assert dataset["data-anim-height-opacity-end"] == 1.0
      assert dataset["data-anim-height-block-interaction"] == "false"
    end

    test "block_interaction true omits false flag attribute" do
      dataset = Height.to_dataset(%Height{block_interaction: true})

      refute Map.has_key?(dataset, "data-anim-height-block-interaction")
    end

    test "custom duration and easing" do
      dataset = Height.to_dataset(%Height{duration: 0.9, easing: "linear"})

      assert dataset["data-anim-height-duration"] == 0.9
      assert dataset["data-anim-height-easing"] == "linear"
    end
  end

  describe "Scale.to_dataset/1" do
    test "default options" do
      dataset = Scale.to_dataset(%Scale{})

      assert dataset["data-anim-scale-duration"] == 0.3
      assert dataset["data-anim-transform-scale-start"] == 0.96
      assert dataset["data-anim-transform-scale-end"] == 1.0
      assert dataset["data-anim-scale-block-interaction"] == "false"
    end

    test "block_interaction true omits false flag attribute" do
      dataset = Scale.to_dataset(%Scale{block_interaction: true})

      refute Map.has_key?(dataset, "data-anim-scale-block-interaction")
    end

    test "custom scale range" do
      dataset =
        Scale.to_dataset(%Scale{
          scale_start: 0.8,
          scale_end: 1.0,
          opacity_start: 0.5,
          opacity_end: 1.0
        })

      assert dataset["data-anim-transform-scale-start"] == 0.8
      assert dataset["data-anim-scale-opacity-start"] == 0.5
    end
  end
end
