defmodule E2eWeb.ToastLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("create_toast", %{"value" => value}, socket) do
    {:noreply,
     Corex.Toast.push_toast(
       socket,
       "This is an info toast",
       "This is an info toast description",
       String.to_atom(value)
     )}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="layout__row">
        <h1>Accordion</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is an info toast",
              "This is an info toast description",
              :info
            )
          }
          class="button"
        >
          Create Info Toast
        </button>

        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is a success toast",
              "This is a success toast description",
              :success
            )
          }
          class="button"
        >
          Succes Toast
        </button>
        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is a error toast",
              "This is a error toast description",
              :error
            )
          }
          class="button"
        >
          Error Toast
        </button>

        <button
          phx-click={
            Corex.Toast.create_toast(
              "This is a loading toast",
              "This is a loading toast description",
              :loading, duration: :infinity)
          }
          class="button"
        >
          Create Loading
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button phx-click="create_toast" value={:info} class="button button--sm">
          Create info
        </button>
        <button phx-click="create_toast" value={:success} class="button button--sm">
          Create success
        </button>
        <button phx-click="create_toast" value={:error} class="button button--sm">
          Create error
        </button>
        <button phx-click="create_toast" value={:loading} class="button button--sm">
          Create loading
        </button>
      </div>
    </Layouts.app>
    """
  end
end
