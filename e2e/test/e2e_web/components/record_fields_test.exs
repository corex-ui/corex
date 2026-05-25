defmodule E2eWeb.RecordFieldsTest do
  use E2eWeb.ConnCase, async: true

  alias E2eWeb.RecordFields

  test "signature_preview renders path data from a string array column" do
    html =
      render_component(&RecordFields.signature_preview/1, %{
        signature: ["M0,0 L10,10 Z", "M20,20 L30,30"]
      })

    assert html =~ ~S|viewBox="-4.0 -4.0 38.0 38.0"|
    assert html =~ ~S|d="M0,0 L10,10 Z"|
    assert html =~ ~S|d="M20,20 L30,30"|
  end
end
