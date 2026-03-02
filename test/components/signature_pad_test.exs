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

  describe "Connect.clear_trigger/1" do
    test "returns clear trigger attributes without hidden when has_paths" do
      assigns = %{id: "test-signature", dir: "ltr", has_paths: true, aria_label: nil}
      result = Connect.clear_trigger(assigns)
      assert result["data-part"] == "clear-trigger"
      refute Map.has_key?(result, "hidden")
    end

    test "returns clear trigger with hidden when no paths" do
      assigns = %{id: "test-signature", dir: "ltr", has_paths: false, aria_label: nil}
      result = Connect.clear_trigger(assigns)
      assert result["hidden"] == "true"
    end
  end

  describe "signature_pad/1 with options" do
    test "renders with controlled" do
      html = render_component(&CorexTest.ComponentHelpers.render_signature_pad_controlled/1, [])
      assert html =~ ~r/data-controlled/
    end

    test "renders with drawing options" do
      html = render_component(&CorexTest.ComponentHelpers.render_signature_pad_drawing_opts/1, [])
      assert html =~ ~r/data-scope="signature-pad"/
    end

    test "renders with on_draw_end" do
      html = render_component(&CorexTest.ComponentHelpers.render_signature_pad_on_draw_end/1, [])
      assert html =~ ~r/data-on-draw-end/
    end

    test "renders with field" do
      html = render_component(&CorexTest.ComponentHelpers.render_signature_pad_with_field/1, [])
      assert html =~ ~r/data-scope="signature-pad"/
      assert html =~ ~r/name="user\[signature\]"/
    end

    test "renders with field value as list" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_signature_pad_with_field/1,
          params: %{"signature" => ["M0 0 L5 5"]}
        )

      assert html =~ ~r/data-scope="signature-pad"/
    end

    test "renders with paths as list" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_signature_pad_with_paths/1,
          paths: ["M0 0 L10 10"]
        )

      assert html =~ ~r/data-scope="signature-pad"/
      assert html =~ ~r/M0 0 L10 10/
    end

    test "renders with paths as JSON string" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_signature_pad_with_paths/1,
          paths: ~s(["M0 0 L10 10"])
        )

      assert html =~ ~r/data-scope="signature-pad"/
    end

    test "renders with errors slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_signature_pad_with_errors/1, [])
      assert html =~ ~r/data-scope="signature-pad"/
      assert html =~ ~r/Required/
    end
  end

  describe "clear/1" do
    test "returns JS command for client-side clear" do
      js = Corex.SignaturePad.clear("my-pad")
      assert %Phoenix.LiveView.JS{} = js
    end
  end
end
