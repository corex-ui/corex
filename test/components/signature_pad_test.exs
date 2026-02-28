defmodule Corex.SignaturePadTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.SignaturePad.Connect

  describe "signature_pad/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_signature_pad/1, [])
      assert html =~ ~r/data-scope="signature-pad"/
      assert html =~ ~r/data-part="root"/
    end
  end

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
