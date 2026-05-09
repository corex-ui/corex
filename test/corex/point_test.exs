defmodule Corex.PointTest do
  use ExUnit.Case, async: true

  alias Corex.Point

  describe "to_map/1" do
    test "nil" do
      assert Point.to_map(nil) == nil
    end

    test "struct" do
      assert Point.to_map(%Point{x: 1, y: 2.5}) == %{x: 1, y: 2.5}
    end

    test "map" do
      assert Point.to_map(%{x: 0, y: 0}) == %{x: 0, y: 0}
    end

    test "rejects invalid" do
      assert_raise ArgumentError, fn -> Point.to_map(%{x: 1}) end
    end
  end
end
