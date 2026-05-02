defmodule E2eWeb.Demos.ToastDemo do
  use E2eWeb, :html

  def api_client_binding_code do
    ~S"""
    <div class="layout__row">
      <.action
        phx-click={Corex.Toast.create_toast("layout-toast", "Info", "Info description", :info, [])}
        class="button button--sm"
      >
        Info
      </.action>
      <.action
        phx-click={Corex.Toast.create_toast("layout-toast", "Success", "Success description", :success, [])}
        class="button button--sm"
      >
        Success
      </.action>
      <.action
        phx-click={Corex.Toast.create_toast("layout-toast", "Error", "Error description", :error, [])}
        class="button button--sm"
      >
        Error
      </.action>
      <.action
        phx-click={Corex.Toast.create_toast("layout-toast", "Loading", "Loading description", :loading, duration: :infinity)}
        class="button button--sm"
      >
        Loading
      </.action>
    </div>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="layout__row">
      <.action
        phx-click={Corex.Toast.create_toast("layout-toast", "Info", "Info description", :info, [])}
        class="button button--sm"
      >
        Info
      </.action>
      <.action
        phx-click={
          Corex.Toast.create_toast("layout-toast", "Success", "Success description", :success, [])
        }
        class="button button--sm"
      >
        Success
      </.action>
      <.action
        phx-click={Corex.Toast.create_toast("layout-toast", "Error", "Error description", :error, [])}
        class="button button--sm"
      >
        Error
      </.action>
      <.action
        phx-click={
          Corex.Toast.create_toast("layout-toast", "Loading", "Loading description", :loading,
            duration: :infinity
          )
        }
        class="button button--sm"
      >
        Loading
      </.action>
    </div>
    """
  end

  def api_create_toast_client_js_heex do
    ~S"""
    <button
      type="button"
      class="button button--sm"
      onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-1', groupId: 'layout-toast', title: 'Info', description: 'From client JS', type: 'info', duration: '5000' } }))"
    >
      Info (client JS)
    </button>
    """
  end

  def api_create_toast_client_js do
    ~S"""
    const el = document.getElementById("layout-toast");
    el?.dispatchEvent(
      new CustomEvent("toast:create", {
        bubbles: false,
        detail: {
          id: "toast-cjs-2",
          groupId: "layout-toast",
          title: "Info",
          description: "From client JS",
          type: "info",
          duration: "5000",
        },
      })
    );
    """
  end

  def api_create_toast_client_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("layout-toast");
    el?.dispatchEvent(
      new CustomEvent("toast:create", {
        bubbles: false,
        detail: {
          id: "toast-cjs-2",
          groupId: "layout-toast",
          title: "Info",
          description: "From client JS",
          type: "info",
          duration: "5000",
        },
      })
    );
    """
  end

  def api_create_toast_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row">
      <button
        type="button"
        class="button button--sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-1', groupId: 'layout-toast', title: 'Info', description: 'From client JS', type: 'info', duration: '5000' } }))"
      >
        Info (client JS)
      </button>
    </div>
    """
  end

  def api_push_toast_server_heex do
    ~S"""
    <.action phx-click="toast_api_info" class="button button--sm">Push info</.action>
    """
  end

  def api_push_toast_server_elixir do
    ~S"""
    def handle_event("toast_api_info", _params, socket) do
      {:noreply,
       Corex.Toast.push_toast(
         socket,
         "layout-toast",
         "Saved",
         "From server",
         :info,
         5000
       )}
    end
    """
  end

  def api_push_toast_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="layout__row">
      <.action phx-click="toast_api_info" class="button button--sm">Push info</.action>
    </div>
    """
  end

  def api_codes do
    %{
      create_toast_client_binding: api_client_binding_code(),
      create_toast_client_js_heex: api_create_toast_client_js_heex(),
      create_toast_client_js: api_create_toast_client_js(),
      create_toast_client_ts: api_create_toast_client_ts(),
      push_toast_server_heex: api_push_toast_server_heex(),
      push_toast_server_elixir: api_push_toast_server_elixir()
    }
  end
end
