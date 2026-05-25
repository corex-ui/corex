defmodule E2e.Form.SignatureFormTest do
  use ExUnit.Case, async: true

  alias E2e.Form.SignatureForm

  test "format_for_toast/1 shows path list" do
    assert SignatureForm.format_for_toast(["M0,0L1,1Z", "M2,2L3,3Z"]) ==
             ~S|signature=["M0,0L1,1Z", "M2,2L3,3Z"]|
  end

  test "format_for_toast/1 truncates long path strings" do
    long = String.duplicate("M", 80)

    assert SignatureForm.format_for_toast([long]) =~
             ~s|signature=["#{String.slice(long, 0, 48)}|
  end

  test "format_for_toast/1 on struct uses signature field" do
    data = %SignatureForm{signature: ["M1"]}
    assert SignatureForm.format_for_toast(data) == ~S|signature=["M1"]|
  end
end
