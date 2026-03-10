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
      <.layout_heading>
        <:title>Editable</:title>
        <:subtitle>Live View</:subtitle>
      </.layout_heading>
      <.editable
        id="my-editable"
        value="My custom value"
        placeholder="Enter Value"
        activation_mode="dblclick"
        select_on_focus
        class="editable"
      >
        <:label>Name</:label>
        <:edit_trigger><.heroicon name="hero-pencil-square" class="icon" /></:edit_trigger>
        <:submit_trigger><.heroicon name="hero-check" class="icon" /></:submit_trigger>
        <:cancel_trigger><.heroicon name="hero-x-mark" class="icon" /></:cancel_trigger>
      </.editable>
    </Layouts.app>
    """
  end
end
