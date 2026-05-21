defmodule Corex.Checkable.HelpersTest do
  use ExUnit.Case, async: true

  alias Corex.Checkable.Helpers

  test "normalize and attr values" do
    assert Helpers.normalize_checked(true)
    refute Helpers.normalize_checked(false)
    assert Helpers.normalize_checked(:indeterminate) == :indeterminate
    assert Helpers.normalize_checked("indeterminate") == :indeterminate
    assert Helpers.normalize_checked("true")
    refute Helpers.normalize_checked("false")
    assert Helpers.normalize_checked(nil) == false
    assert Helpers.normalize_checked(:other) == false
    assert Helpers.checked_attr_value(:indeterminate) == "indeterminate"
    assert Helpers.checked_controlled_attr(true, true) == "true"
    assert Helpers.checked_controlled_attr(true, :indeterminate) == "indeterminate"
    assert Helpers.checked_default_attr(false, false) == nil
    assert Helpers.checked_default_attr(false, true) == "true"
    refute Helpers.checked_default_attr(true, false)
    assert Helpers.native_checked(true) == true
    assert Helpers.visual_state(:indeterminate) == "indeterminate"
  end
end
