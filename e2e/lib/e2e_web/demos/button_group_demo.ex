defmodule E2eWeb.Demos.ButtonGroupDemo do
  use E2eWeb, :html

  # @parity anatomy: "minimal"
  def anatomy_minimal_code do
    ~S"""
    <.button_group id="toolbar-actions" class="button-group" aria_label="Document actions">
      <.action type="button" class="button">Edit</.action>
      <.action type="button" class="button">Duplicate</.action>
      <.action type="button" class="button ui-alert">Delete</.action>
    </.button_group>
    """
  end

  def anatomy_minimal_example(assigns) do
    ~H"""
    <.button_group id="button-group-anatomy-minimal" class="button-group" aria_label="Document actions">
      <.action type="button" class="button">Edit</.action>
      <.action type="button" class="button">Duplicate</.action>
      <.action type="button" class="button ui-alert">Delete</.action>
    </.button_group>
    """
  end
end
