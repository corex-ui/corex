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
      <.avatar id="my-avatar" src="" class="avatar">
        <:fallback>JD</:fallback>
      </.avatar>
    </Layouts.app>
    """
  end
end
