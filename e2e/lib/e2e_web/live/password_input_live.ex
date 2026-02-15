defmodule E2eWeb.PasswordInputLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Password Input</h1>
        <h2>Live View</h2>
      </div>
      <.password_input id="my-password-input" class="password-input">
        <:label>Password</:label>
      </.password_input>
    </Layouts.app>
    """
  end
end
