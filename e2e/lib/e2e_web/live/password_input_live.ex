defmodule E2eWeb.PasswordInputLive do
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
        <h1>Password Input</h1>
        <h2>Live View</h2>
      </div>
      <div class="layout__row flex flex-col gap-ui">
        <.password_input id="password-with-visibility" name="user[password]" class="password-input">
          <:label>Password</:label>
          <:visible_indicator><.icon name="hero-eye" class="icon" /></:visible_indicator>
          <:hidden_indicator><.icon name="hero-eye-slash" class="icon" /></:hidden_indicator>
        </.password_input>
        <.password_input id="password-basic" name="user[password]" class="password-input">
          <:label>Password</:label>
        </.password_input>
      </div>
    </Layouts.app>
    """
  end
end
