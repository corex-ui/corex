defmodule Corex.QrCodeTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.QrCode, only: [qr_code: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.qr_code id="qr-code-unit" class="qr-code" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="QrCode")
    assert html =~ ~S(data-scope="qr-code")
  end
end
