defmodule E2eWeb.MenuLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_value", %{"value" => value}, socket) do
    {:noreply, Corex.Menu.set_open(socket, "my-menu", value == "true")}
  end

  # def handle_event("handle_on_select", %{"id" => _id, "value" => value}, socket) do
  #   {:noreply, push_navigate(socket, to: "/#{value}")}
  # end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Menu</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Menu.set_open("my-menu", true)}
          class="button button--sm"
        >
          Open menu
        </button>
        <button
          phx-click={Corex.Menu.set_open("my-menu", false)}
          class="button button--sm"
        >
          Close menu
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_value" value="true" class="button button--sm">
          Open menu
        </button>
        <button
          phx-click="set_value"
          value="false"
          class="button button--sm"
        >
          Close menu
        </button>
      </div>
    </Layouts.app>
    """
  end
end
