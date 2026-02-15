defmodule E2eWeb.EditableLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Editable</h1>
        <h2>Live View</h2>
      </div>
      <.editable
        id="my-editable"
        value="My custom value"
        placeholder="Enter Value"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
      >
        <:label>Name</:label>
      </.editable>
    </Layouts.app>
    """
  end
end
