defmodule E2eWeb.DialogLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("set_open", %{"value" => "true"}, socket) do
    {:noreply, Corex.Dialog.set_open(socket, "my-dialog", true)}
  end

  def handle_event("set_open", %{"value" => "false"}, socket) do
    {:noreply, Corex.Dialog.set_open(socket, "my-dialog", false)}
  end

  def handle_event("open_change", %{"id" => _id, "open" => _open}, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="layout__row">
        <h1>Dialog</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.Dialog.set_open("my-dialog", true)}
          class="button button--sm"
        >
          Open Dialog
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="set_open" value="true" class="button button--sm">
          Open Dialog
        </button>
      </div>

      <.dialog
        id="my-dialog"
        on_open_change="open_change"
        class="dialog"
      >
        <:trigger>Open Dialog</:trigger>
        <:title>Dialog Title</:title>
        <:description>
          This is a dialog description that explains what the dialog is about.
        </:description>
        <:content>
          <p>Dialog content goes here. You can add any content you want inside the dialog.</p>
          <div class="layout__row">
            <button
              phx-click={Corex.Dialog.set_open("my-dialog", false)}
              class="button button--sm"
            >
              Client Close Dialog
            </button>
            <button phx-click="set_open" value="false" class="button button--sm">
              Server Close Dialog
            </button>
          </div>
        </:content>
        <:close_trigger>
          <.icon name="hero-x-mark" class="icon" />
        </:close_trigger>
      </.dialog>
    </Layouts.app>
    """
  end
end
