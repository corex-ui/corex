defmodule Corex.ValueTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias Corex.Value

  describe "coerce_string_list/2" do
    test "returns empty list for empty input" do
      assert Value.coerce_string_list([], "ctx") == []
    end

    test "returns list when all elements are strings" do
      assert Value.coerce_string_list(["a", "b"], "ctx") == ["a", "b"]
      assert Value.coerce_string_list(["x"], "ctx") == ["x"]
    end

    test "drops a list with non-strings and warns naming the caller" do
      log =
        capture_log(fn -> assert Value.coerce_string_list([1, 2, 3], "Corex.X.y/2") == [] end)

      assert log =~ "Corex.X.y/2"
      assert log =~ "value must be a list of strings"
      assert log =~ "[1, 2, 3]"

      assert capture_log(fn -> assert Value.coerce_string_list(["a", :atom], "ctx") == [] end) =~
               "value must be a list of strings"
    end

    test "drops non-list input and warns" do
      for bad <- ["string", %{}, 123] do
        assert capture_log(fn -> assert Value.coerce_string_list(bad, "ctx") == [] end) =~
                 "value must be a list of strings"
      end
    end
  end

  describe "coerce_string_list/1" do
    test "coerces silently for internal callers" do
      assert Value.coerce_string_list(["a"]) == ["a"]

      assert capture_log(fn ->
               assert Value.coerce_string_list([1]) == []
               assert Value.coerce_string_list("nope") == []
             end) == ""
    end
  end

  describe "parse_string_list/3" do
    test "parses csv string" do
      assert Value.parse_string_list("a, b", "ctx") == ["a", "b"]
    end

    test "graphemes option splits string without comma" do
      assert Value.parse_string_list("12", "ctx", graphemes: true) == ["1", "2"]
    end

    test "without graphemes a comma-free string is a single entry" do
      assert Value.parse_string_list("ab", "ctx") == ["ab"]
    end

    test "blank string is empty" do
      assert Value.parse_string_list("   ", "ctx") == []
    end

    test "a list passes through the list coercion" do
      assert Value.parse_string_list(["a"], "ctx") == ["a"]
      assert capture_log(fn -> assert Value.parse_string_list([1], "ctx") == [] end) =~ "ctx"
    end
  end

  describe "coerce_string_value/2" do
    test "accepts string and nil" do
      assert Value.coerce_string_value("tab", "ctx") == "tab"
      assert Value.coerce_string_value(nil, "ctx") == nil
    end

    test "warns and returns nil for an invalid value" do
      log =
        capture_log(fn ->
          assert Value.coerce_string_value(123, "Corex.Tabs.set_value/2") == nil
        end)

      assert log =~ "Corex.Tabs.set_value/2"
      assert log =~ "value must be a string or nil"
    end
  end
end
