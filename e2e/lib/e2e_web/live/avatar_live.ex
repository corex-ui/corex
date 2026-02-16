defmodule E2eWeb.AvatarLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Avatar</h1>
        <h2>Live View</h2>
      </div>
      <div class="layout__row gap-ui-gap">
        <.avatar id="avatar-fallback" src="" class="avatar">
          <:fallback>JD</:fallback>
        </.avatar>
        <.avatar id="avatar-cat" src={~p"/images/avatar.png"} alt="Avatar" class="avatar">
          <:fallback>?</:fallback>
        </.avatar>
        <.avatar id="avatar-favicon" src={~p"/images/favicon.ico"} alt="Favicon" class="avatar">
          <:fallback>FX</:fallback>
        </.avatar>
      </div>
    </Layouts.app>
    """
  end
end
