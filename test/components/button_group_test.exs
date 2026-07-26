defmodule Corex.ButtonGroupTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component
  import Corex.ButtonGroup
  import Corex.Action

  test "renders role=group with slotted actions" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.button_group id="bg-1" class="button-group" aria_label="Actions">
        <.action type="button" class="button">One</.action>
        <.action type="button" class="button ui-accent ui-solid">Two</.action>
      </.button_group>
      """)

    assert html =~ ~S(id="bg-1")
    assert html =~ ~S(role="group")
    assert html =~ ~S(aria-label="Actions")
    assert html =~ "button-group"
    assert html =~ "One"
    assert html =~ "Two"
  end
end
