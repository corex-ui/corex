defmodule Corex.AnimationTest do
  use ExUnit.Case, async: true

  test "namespace module loads" do
    for mod <- [Corex.Animation, Corex.Animation.Height, Corex.Animation.Scale] do
      assert {:module, _} = Code.ensure_loaded(mod)
    end
  end
end
