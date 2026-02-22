defmodule Corex.SignaturePadTest do
  use ExUnit.Case, async: true

  alias Corex.SignaturePad.Connect

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-signature", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "signature-pad:test-signature"
      assert result["data-scope"] == "signature-pad"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-signature", dir: "ltr"}
      result = Connect.control(assigns)
      assert result["id"] == "signature-pad:test-signature:control"
    end
  end
end
