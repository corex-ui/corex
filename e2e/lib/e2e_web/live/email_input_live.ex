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
      <div class="layout__row flex flex-col gap-ui">
        <.email_input id="email-with-icon" name="user[email]" class="email-input">
          <:label>Email</:label>
          <:icon><.icon name="hero-envelope" class="icon" /></:icon>
        </.email_input>
        <.email_input id="email-basic" name="user[email]" class="email-input">
          <:label>Email</:label>
        </.email_input>
        <.email_input
          id="email-placeholder"
          name="user[email]"
          class="email-input"
          placeholder="you@example.com"
        >
          <:label>Email</:label>
        </.email_input>
      </div>
    </Layouts.app>
    """
  end
end
