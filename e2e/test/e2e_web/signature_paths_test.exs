defmodule E2eWeb.SignaturePathsTest do
  use ExUnit.Case, async: true

  alias E2eWeb.SignaturePaths

  test "parses newline-separated path d strings from the signature pad" do
    s = "M0,0 L10,10 Z\nM20,20 L30,30"
    assert SignaturePaths.path_d_list(s) == ["M0,0 L10,10 Z", "M20,20 L30,30"]
  end

  test "parses single path without newline" do
    assert SignaturePaths.path_d_list("M0,0L1,1Z") == ["M0,0L1,1Z"]
  end

  test "parses json array of paths" do
    assert SignaturePaths.path_d_list(~s'["M1 1","M2 2"]') == ["M1 1", "M2 2"]
  end

  test "nil and empty" do
    assert SignaturePaths.path_d_list(nil) == []
    assert SignaturePaths.path_d_list("") == []
  end
end
