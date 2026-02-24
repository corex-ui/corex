defmodule E2eWeb.TextInputLive do
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
        <h1>Text Input</h1>
        <h2>Live View</h2>
      </div>
      <.text_input id="my-text-input" name="user[name]" class="text-input">
        <:label>Name</:label>
      </.text_input>
    </Layouts.app>
    """
  end
end
