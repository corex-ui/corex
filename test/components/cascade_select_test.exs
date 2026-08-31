defmodule Corex.CascadeSelectTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.CascadeSelect, only: [cascade_select: 1]

  alias Corex.CascadeSelect.Connect

  test "renders closed overlay on the server" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.cascade_select id="cascade-select-unit" class="cascade-select" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="CascadeSelect")
    assert html =~ ~S(data-scope="cascade-select")
    assert html =~ ~S(data-part="positioner")
    assert html =~ ~S(data-part="content")
    assert html =~ "translate3d(0, -100vh, 0)"
    assert html =~ ~S(hidden)
    refute html =~ ~S(data-state="open")
  end

  test "Connect.content stamps hidden closed attributes" do
    result = Connect.content(%{id: "cs", dir: "ltr"})
    assert result["hidden"] == true
    refute Map.has_key?(result, "aria-hidden")
    refute Map.has_key?(result, "style")
  end
end
