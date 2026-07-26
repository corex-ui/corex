defmodule Corex.ValueBindingTest do
  use ExUnit.Case, async: true

  alias Corex.ValueBinding

  describe "controlled_string_value/2" do
    test "controlled mode uses value only" do
      assert ValueBinding.controlled_string_value(true, "a") == {"a", nil}
    end

    test "uncontrolled mode uses default value only" do
      assert ValueBinding.controlled_string_value(false, "a") == {nil, "a"}
    end

    test "nil value yields nil pair" do
      assert ValueBinding.controlled_string_value(true, nil) == {nil, nil}
    end
  end

  describe "controlled_dataset_values/2" do
    test "controlled mode uses value only" do
      assert ValueBinding.controlled_dataset_values(true, "a,b") == {"a,b", nil}
    end

    test "uncontrolled mode uses default value only" do
      assert ValueBinding.controlled_dataset_values(false, "a,b") == {nil, "a,b"}
    end

    test "nil joined yields nil pair" do
      assert ValueBinding.controlled_dataset_values(true, nil) == {nil, nil}
    end
  end

  describe "list_pair/2" do
    test "controlled with values encodes into the value slot" do
      assert {json, nil} = ValueBinding.list_pair(["a", "b"], true)
      assert json == ~S(["a","b"])
    end

    test "controlled with no values still sends an empty list so the hook clears" do
      assert ValueBinding.list_pair([], true) == {"[]", nil}
      assert ValueBinding.list_pair(nil, true) == {"[]", nil}
    end

    test "uncontrolled with values encodes into the default slot" do
      assert {nil, json} = ValueBinding.list_pair(["a"], false)
      assert json == ~S(["a"])
    end

    test "uncontrolled with no values emits neither" do
      assert ValueBinding.list_pair([], false) == {nil, nil}
      assert ValueBinding.list_pair(nil, false) == {nil, nil}
    end
  end
end
