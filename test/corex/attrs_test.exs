defmodule Corex.AttrsTest do
  use ExUnit.Case, async: true

  alias Corex.Attrs

  describe "presence_attr/1" do
    test "emits a bare attribute for a truthy state" do
      assert Attrs.presence_attr(true) == ""
      assert Attrs.presence_attr("x") == ""
    end

    test "omits the attribute for a falsy state" do
      assert Attrs.presence_attr(false) == nil
      assert Attrs.presence_attr(nil) == nil
    end
  end

  describe "presence_attr/2" do
    test "emits only when controlled and the value is truthy" do
      assert Attrs.presence_attr(true, true) == ""
      assert Attrs.presence_attr(true, "x") == ""
    end

    test "omits when controlled and the value is falsy" do
      assert Attrs.presence_attr(true, false) == nil
      assert Attrs.presence_attr(true, nil) == nil
    end

    test "omits when uncontrolled" do
      assert Attrs.presence_attr(false, true) == nil
      assert Attrs.presence_attr(nil, true) == nil
    end
  end

  describe "default_presence_attr/2" do
    test "emits only when uncontrolled and the value is truthy" do
      assert Attrs.default_presence_attr(false, true) == ""
      assert Attrs.default_presence_attr(nil, true) == ""
    end

    test "omits when uncontrolled and the value is falsy" do
      assert Attrs.default_presence_attr(false, false) == nil
      assert Attrs.default_presence_attr(false, nil) == nil
    end

    test "omits when controlled, so the hook reads server state instead" do
      assert Attrs.default_presence_attr(true, true) == nil
      assert Attrs.default_presence_attr(true, false) == nil
    end
  end

  describe "data_state/3" do
    test "picks the branch matching the state" do
      assert Attrs.data_state(true, "on", "off") == "on"
      assert Attrs.data_state(false, "on", "off") == "off"
      assert Attrs.data_state(nil, "on", "off") == "off"
    end
  end

  describe "maybe_put/3" do
    test "skips nil values" do
      assert Attrs.maybe_put(%{}, :k, nil) == %{}
      assert Attrs.maybe_put(%{}, :k, "v") == %{k: "v"}
      assert Attrs.maybe_put(%{}, :k, false) == %{k: false}
    end
  end

  describe "dir attributes" do
    test "accepts only ltr and rtl" do
      assert Attrs.put_data_dir_attr(%{}, "ltr") == %{"data-dir" => "ltr"}
      assert Attrs.put_dir_attr(%{}, "rtl") == %{"dir" => "rtl"}
      assert Attrs.put_data_dir_attr(%{}, "sideways") == %{}
      assert Attrs.put_dir_attr(%{}, nil) == %{}
    end

    test "reads :dir out of assigns" do
      assert Attrs.put_data_dir_attr_from_assigns(%{}, %{dir: "ltr"}) == %{"data-dir" => "ltr"}
      assert Attrs.put_dir_attr_from_assigns(%{}, %{dir: "rtl"}) == %{"dir" => "rtl"}
      assert Attrs.put_dir_attr_from_assigns(%{}, %{}) == %{}
    end
  end
end
