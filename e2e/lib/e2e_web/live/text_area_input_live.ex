defmodule E2eWeb.TextAreaInputLive do
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
        <h1>Text Area Input</h1>
        <h2>Live View</h2>
      </div>
      <.text_area_input id="my-text-area-input" name="user[bio]" class="text-area-input">
        <:label>Bio</:label>
      </.text_area_input>
    </Layouts.app>
    """
  end
end
