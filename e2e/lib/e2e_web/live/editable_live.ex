defmodule E2eWeb.EditableLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      locale={@locale}
      current_path={@current_path}
    >
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
        <:edit_trigger><.icon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.icon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.icon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
    </Layouts.app>
    """
  end
end
