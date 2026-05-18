defmodule Corex.AnimationTest do
  use ExUnit.Case, async: true

  test "namespace module loads" do
    assert Code.ensure_loaded?(Corex.Animation)
    assert function_exported?(Corex.Animation.Height, :__info__, 1)
    assert function_exported?(Corex.Animation.Scale, :__info__, 1)
  end
end
