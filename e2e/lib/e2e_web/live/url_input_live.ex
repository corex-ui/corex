defmodule E2eWeb.UrlInputLive do
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
        <h1>URL Input</h1>
        <h2>Live View</h2>
      </div>
      <.url_input id="my-url-input" name="user[website]" class="url-input">
        <:label>Website</:label>
      </.url_input>
    </Layouts.app>
    """
  end
end
