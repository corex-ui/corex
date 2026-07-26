defmodule Corex.PointTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

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

    test "warns and returns nil for an incomplete point" do
      log = capture_log(fn -> assert Point.to_map(%{x: 1}) == nil end)

      assert log =~ "expected %Corex.Point{}"
      assert log =~ "ignoring it"
    end

    test "warns and returns nil for non-numeric coordinates" do
      assert capture_log(fn -> assert Point.to_map(%{x: "1", y: "2"}) == nil end) =~
               "expected %Corex.Point{}"
    end
  end
end
