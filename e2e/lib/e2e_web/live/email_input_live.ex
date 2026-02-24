defmodule E2eWeb.EmailInputLive do
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
        <h1>Email Input</h1>
        <h2>Live View</h2>
      </div>
      <.email_input id="my-email-input" name="user[email]" class="email-input">
        <:label>Email</:label>
      </.email_input>
    </Layouts.app>
    """
  end
end
