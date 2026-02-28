defmodule Corex.HelpersTest do
  use ExUnit.Case, async: true

  alias Corex.Helpers

  describe "get_boolean/1" do
    test "returns empty string for true" do
      assert Helpers.get_boolean(true) == ""
    end

    test "returns nil for false" do
      assert Helpers.get_boolean(false) == nil
    end

    test "returns nil for nil" do
      assert Helpers.get_boolean(nil) == nil
    end
  end

  describe "get_boolean/2" do
    test "returns empty string when controlled and value is truthy" do
      assert Helpers.get_boolean(true, true) == ""
      assert Helpers.get_boolean(true, "x") == ""
    end

    test "returns nil when controlled and value is falsy" do
      assert Helpers.get_boolean(true, false) == nil
      assert Helpers.get_boolean(true, nil) == nil
    end

    test "returns nil when uncontrolled" do
      assert Helpers.get_boolean(false, true) == nil
      assert Helpers.get_boolean(false, false) == nil
      assert Helpers.get_boolean(nil, true) == nil
    end
  end

  describe "get_default_boolean/2" do
    test "returns empty string when uncontrolled and value is truthy" do
      assert Helpers.get_default_boolean(false, true) == ""
    end

    test "returns nil when uncontrolled and value is falsy" do
      assert Helpers.get_default_boolean(false, false) == nil
      assert Helpers.get_default_boolean(false, nil) == nil
    end

    test "returns nil when controlled" do
      assert Helpers.get_default_boolean(true, true) == nil
      assert Helpers.get_default_boolean(true, false) == nil
    end
  end

  describe "validate_value!/1" do
    test "returns empty list for empty input" do
      assert Helpers.validate_value!([]) == []
    end

    test "returns list when all elements are strings" do
      assert Helpers.validate_value!(["a", "b"]) == ["a", "b"]
      assert Helpers.validate_value!(["x"]) == ["x"]
    end

    test "raises when list contains non-strings" do
      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!([1, 2, 3])
      end

      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!(["a", :atom])
      end
    end

    test "raises for non-list input" do
      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!("string")
      end

      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!(%{})
      end

      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Helpers.validate_value!(123)
      end
    end
  end
end
