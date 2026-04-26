defmodule Corex.AnimationTest do
  use ExUnit.Case, async: true

  alias Corex.Animation.{Height, Scale}

  describe "Corex.Animation.Scale.to_dataset/1" do
    test "emits data-anim-scale-* and transform scale keys" do
      a = %Scale{
        duration: 0.4,
        easing: "ease-out",
        opacity_start: 0.1,
        opacity_end: 0.9,
        scale_start: 0.95,
        scale_end: 1.0
      }

      assert Scale.to_dataset(a) == %{
               "data-anim-scale-block-interaction" => "false",
               "data-anim-scale-duration" => 0.4,
               "data-anim-scale-easing" => "ease-out",
               "data-anim-scale-opacity-start" => 0.1,
               "data-anim-scale-opacity-end" => 0.9,
               "data-anim-transform-scale-start" => 0.95,
               "data-anim-transform-scale-end" => 1.0
             }
    end

    test "emits data-anim-scale-block-interaction when block_interaction is false" do
      a = %Scale{block_interaction: false}

      assert Map.get(Scale.to_dataset(a), "data-anim-scale-block-interaction") == "false"
    end
  end

  describe "Corex.Animation.Height.to_dataset/1" do
    test "emits data-anim-height-* keys" do
      a = %Height{duration: 0.2, easing: "linear", opacity_start: 0.0, opacity_end: 1.0}

      assert Height.to_dataset(a) == %{
               "data-anim-height-block-interaction" => "false",
               "data-anim-height-duration" => 0.2,
               "data-anim-height-easing" => "linear",
               "data-anim-height-opacity-start" => 0.0,
               "data-anim-height-opacity-end" => 1.0
             }
    end

    test "emits data-anim-height-block-interaction when block_interaction is false" do
      a = %Height{block_interaction: false}

      assert Map.get(Height.to_dataset(a), "data-anim-height-block-interaction") == "false"
    end
  end
end
