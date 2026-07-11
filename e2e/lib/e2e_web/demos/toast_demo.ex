defmodule E2eWeb.Demos.ToastDemo do
  use E2eWeb, :html

  alias Phoenix.LiveView.JS

  def api_client_binding_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Info", "Info description", :info, [])}
        class="button ui-size-sm"
      >
        Info
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Success", "Success description", :success, [])}
        class="button ui-size-sm"
      >
        Success
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Error", "Error description", :error, [])}
        class="button ui-size-sm"
      >
        Error
      </.action>
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "Loading", "Loading description", :info,
            duration: :infinity,
            loading: true
          )
        }
        class="button ui-size-sm"
      >
        Loading
      </.action>
    </div>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Info", "Info description", :info, [])}
        class="button ui-size-sm"
      >
        Info
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Success", "Success description", :success, [])}
        class="button ui-size-sm"
      >
        Success
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Error", "Error description", :error, [])}
        class="button ui-size-sm"
      >
        Error
      </.action>
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "Loading", "Loading description", :info,
            duration: :infinity,
            loading: true
          )
        }
        class="button ui-size-sm"
      >
        Loading
      </.action>
    </div>
    """
  end

  def api_create_client_js_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-info', groupId: 'layout-toast', title: 'Info', description: 'From client JS', type: 'info', duration: '5000' } }))"
      >
        Info
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-success', groupId: 'layout-toast', title: 'Success', description: 'From client JS', type: 'success', duration: '5000' } }))"
      >
        Success
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-error', groupId: 'layout-toast', title: 'Error', description: 'From client JS', type: 'error', duration: '5000' } }))"
      >
        Error
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-loading', groupId: 'layout-toast', title: 'Loading', description: 'From client JS', type: 'info', duration: 'Infinity', loading: true } }))"
      >
        Loading
      </button>
    </div>
    """
  end

  def api_create_client_js do
    ~S"""
    const el = document.getElementById("layout-toast");
    const dispatch = (detail) =>
      el?.dispatchEvent(
        new CustomEvent("toast:create", { bubbles: false, detail: { groupId: "layout-toast", ...detail } })
      );

    dispatch({
      id: "toast-cjs-info",
      title: "Info",
      description: "From client JS",
      type: "info",
      duration: "5000",
    });

    dispatch({
      id: "toast-cjs-success",
      title: "Success",
      description: "From client JS",
      type: "success",
      duration: "5000",
    });

    dispatch({
      id: "toast-cjs-error",
      title: "Error",
      description: "From client JS",
      type: "error",
      duration: "5000",
    });

    dispatch({
      id: "toast-cjs-loading",
      title: "Loading",
      description: "From client JS",
      type: "info",
      duration: "Infinity",
      loading: true,
    });
    """
  end

  def api_create_client_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("layout-toast");
    const dispatch = (detail: Record<string, unknown>) =>
      el?.dispatchEvent(
        new CustomEvent("toast:create", { bubbles: false, detail: { groupId: "layout-toast", ...detail } })
      );

    dispatch({
      id: "toast-cjs-info",
      title: "Info",
      description: "From client JS",
      type: "info",
      duration: "5000",
    });

    dispatch({
      id: "toast-cjs-success",
      title: "Success",
      description: "From client JS",
      type: "success",
      duration: "5000",
    });

    dispatch({
      id: "toast-cjs-error",
      title: "Error",
      description: "From client JS",
      type: "error",
      duration: "5000",
    });

    dispatch({
      id: "toast-cjs-loading",
      title: "Loading",
      description: "From client JS",
      type: "info",
      duration: "Infinity",
      loading: true,
    });
    """
  end

  def api_create_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-info', groupId: 'layout-toast', title: 'Info', description: 'From client JS', type: 'info', duration: '5000' } }))"
      >
        Info
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-success', groupId: 'layout-toast', title: 'Success', description: 'From client JS', type: 'success', duration: '5000' } }))"
      >
        Success
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-error', groupId: 'layout-toast', title: 'Error', description: 'From client JS', type: 'error', duration: '5000' } }))"
      >
        Error
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-cjs-loading', groupId: 'layout-toast', title: 'Loading', description: 'From client JS', type: 'info', duration: 'Infinity', loading: true } }))"
      >
        Loading
      </button>
    </div>
    """
  end

  def api_create_server_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="toast_api_push_info" class="button ui-size-sm">Info</.action>
      <.action phx-click="toast_api_push_success" class="button ui-size-sm">Success</.action>
      <.action phx-click="toast_api_push_error" class="button ui-size-sm">Error</.action>
      <.action phx-click="toast_api_push_loading" class="button ui-size-sm">Loading</.action>
    </div>
    """
  end

  def api_create_server_elixir do
    ~S"""
    def handle_event("toast_api_push_info", _params, socket) do
      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "Info", "From server", :info, duration: 5000)}
    end

    def handle_event("toast_api_push_success", _params, socket) do
      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "Success", "From server", :success, duration: 5000)}
    end

    def handle_event("toast_api_push_error", _params, socket) do
      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "Error", "From server", :error, duration: 5000)}
    end

    def handle_event("toast_api_push_loading", _params, socket) do
      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "Loading", "From server", :info, duration: :infinity,
         loading: true
       )}
    end
    """
  end

  def api_create_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="toast_api_push_info" class="button ui-size-sm">Info</.action>
      <.action phx-click="toast_api_push_success" class="button ui-size-sm">Success</.action>
      <.action phx-click="toast_api_push_error" class="button ui-size-sm">Error</.action>
      <.action phx-click="toast_api_push_loading" class="button ui-size-sm">Loading</.action>
    </div>
    """
  end

  def api_update_toast_client_binding_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "Before update", "Create this toast once, then tap Update.", :info,
            id: "toast-api-update-demo",
            duration: 60_000
          )
        }
        class="button ui-size-sm"
      >
        Create demo toast
      </.action>
      <.action
        phx-click={
          Corex.Toast.update("layout-toast", "toast-api-update-demo", %{
            title: "After update",
            description: "Updated via Corex.Toast.update/3",
            type: :success,
            duration: 5000
          })
        }
        class="button ui-size-sm"
      >
        Update
      </.action>
    </div>
    """
  end

  def api_update_toast_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Corex.Toast.create(
            "layout-toast",
            "Before update",
            "Create this toast once, then tap Update.",
            :info,
            id: "toast-api-update-demo",
            duration: 60_000
          )
        }
        class="button ui-size-sm"
      >
        Create demo toast
      </.action>
      <.action
        phx-click={
          Corex.Toast.update("layout-toast", "toast-api-update-demo", %{
            title: "After update",
            description: "Updated via Corex.Toast.update/3",
            type: :success,
            duration: 5000
          })
        }
        class="button ui-size-sm"
      >
        Update
      </.action>
    </div>
    """
  end

  def api_update_toast_client_js_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-api-update-demo', groupId: 'layout-toast', title: 'Before update', description: 'Create once then tap Update.', type: 'info', duration: '60000' } }))"
      >
        Create demo toast
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:update', {bubbles: false, detail: { id: 'toast-api-update-demo', groupId: 'layout-toast', title: 'After update', description: 'Updated via toast:update', type: 'success', duration: '5000' } }))"
      >
        Update
      </button>
    </div>
    """
  end

  def api_update_toast_client_js do
    ~S"""
    const el = document.getElementById("layout-toast");
    el?.dispatchEvent(
      new CustomEvent("toast:create", {
        bubbles: false,
        detail: {
          id: "toast-api-update-demo",
          groupId: "layout-toast",
          title: "Before update",
          description: "Create once then call update.",
          type: "info",
          duration: "60000",
        },
      })
    );

    el?.dispatchEvent(
      new CustomEvent("toast:update", {
        bubbles: false,
        detail: {
          id: "toast-api-update-demo",
          groupId: "layout-toast",
          title: "After update",
          description: "Updated via toast:update",
          type: "success",
          duration: "5000",
        },
      })
    );
    """
  end

  def api_update_toast_client_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("layout-toast");
    el?.dispatchEvent(
      new CustomEvent("toast:create", {
        bubbles: false,
        detail: {
          id: "toast-api-update-demo",
          groupId: "layout-toast",
          title: "Before update",
          description: "Create once then call update.",
          type: "info",
          duration: "60000",
        },
      })
    );

    el?.dispatchEvent(
      new CustomEvent("toast:update", {
        bubbles: false,
        detail: {
          id: "toast-api-update-demo",
          groupId: "layout-toast",
          title: "After update",
          description: "Updated via toast:update",
          type: "success",
          duration: "5000",
        },
      })
    );
    """
  end

  def api_update_toast_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:create', {bubbles: false, detail: { id: 'toast-api-update-demo', groupId: 'layout-toast', title: 'Before update', description: 'Create once then tap Update.', type: 'info', duration: '60000' } }))"
      >
        Create demo toast
      </button>
      <button
        type="button"
        class="button ui-size-sm"
        onclick="document.getElementById('layout-toast')?.dispatchEvent(new CustomEvent('toast:update', {bubbles: false, detail: { id: 'toast-api-update-demo', groupId: 'layout-toast', title: 'After update', description: 'Updated via toast:update', type: 'success', duration: '5000' } }))"
      >
        Update
      </button>
    </div>
    """
  end

  def api_update_toast_server_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="toast_api_seed_update_demo" class="button ui-size-sm">Create demo toast</.action>
      <.action phx-click="toast_api_update_demo" class="button ui-size-sm">Update</.action>
    </div>
    """
  end

  def api_update_toast_server_elixir do
    ~S"""
    def handle_event("toast_api_seed_update_demo", _params, socket) do
      {:noreply,
       Corex.Toast.create(socket, "layout-toast", "Before update", "Create once then tap Update.", :info,
         id: "toast-api-update-demo",
         duration: 60_000
       )}
    end

    def handle_event("toast_api_update_demo", _params, socket) do
      {:noreply,
       Corex.Toast.update(socket, "layout-toast", "toast-api-update-demo", %{
         title: "After update",
         description: "Updated from server",
         type: :success,
         duration: 5000
       })}
    end
    """
  end

  def api_update_toast_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="toast_api_seed_update_demo" class="button ui-size-sm">
        Create demo toast
      </.action>
      <.action phx-click="toast_api_update_demo" class="button ui-size-sm">Update</.action>
    </div>
    """
  end

  def anatomy_type_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Info", "Client binding", :info, [])}
        class="button ui-size-sm"
      >
        Info
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Success", "Client binding", :success, [])}
        class="button ui-size-sm"
      >
        Success
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Error", "Client binding", :error, [])}
        class="button ui-size-sm"
      >
        Error
      </.action>
    </div>
    """
  end

  def anatomy_type_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Info", "Client binding", :info, [])}
        class="button ui-size-sm"
      >
        Info
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Success", "Client binding", :success, [])}
        class="button ui-size-sm"
      >
        Success
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "Error", "Client binding", :error, [])}
        class="button ui-size-sm"
      >
        Error
      </.action>
    </div>
    """
  end

  def anatomy_duration_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Toast.create("layout-toast", "2 seconds", "duration: 2000", :info, duration: 2000)}
        class="button ui-size-sm"
      >
        2s
      </.action>
      <.action
        phx-click={Corex.Toast.create("layout-toast", "5 seconds", "duration: 5000 (default)", :info, duration: 5000)}
        class="button ui-size-sm"
      >
        5s
      </.action>
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "Persistent", "duration: :infinity", :info, duration: :infinity)
        }
        class="button ui-size-sm"
      >
        Infinity
      </.action>
    </div>
    """
  end

  def anatomy_duration_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "2 seconds", "duration: 2000", :info, duration: 2000)
        }
        class="button ui-size-sm"
      >
        2s
      </.action>
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "5 seconds", "duration: 5000 (default)", :info,
            duration: 5000
          )
        }
        class="button ui-size-sm"
      >
        5s
      </.action>
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "Persistent", "duration: :infinity", :info,
            duration: :infinity
          )
        }
        class="button ui-size-sm"
      >
        Infinity
      </.action>
    </div>
    """
  end

  def anatomy_loading_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Toast.create("layout-toast", "No loading", "Default slot", :info, duration: 5000)}
        class="button ui-size-sm"
      >
        No loading
      </.action>
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "Loading", "loading: true", :info,
            duration: :infinity,
            loading: true
          )
        }
        class="button ui-size-sm"
      >
        Loading
      </.action>
    </div>
    """
  end

  def anatomy_loading_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "No loading", "Default slot", :info, duration: 5000)
        }
        class="button ui-size-sm"
      >
        No loading
      </.action>
      <.action
        phx-click={
          Corex.Toast.create("layout-toast", "Loading", "loading: true", :info,
            duration: :infinity,
            loading: true
          )
        }
        class="button ui-size-sm"
      >
        Loading
      </.action>
    </div>
    """
  end

  def anatomy_trigger_redirect_code do
    ~S"""
    <.action
      phx-click={
        Corex.Toast.create("layout-toast", "Saved", "Action redirects to this anatomy page.", :success,
          id: "toast-anatomy-redirect",
          duration: 30_000,
          action: %{
            label: "Same page",
            class: "button ui-accent ui-size-sm",
            js: JS.patch(~p"/toast/anatomy")
          }
        )
      }
      class="button ui-size-sm"
    >
      Toast with redirect
    </.action>
    """
  end

  def anatomy_trigger_redirect_example(assigns) do
    ~H"""
    <.action
      phx-click={
        Corex.Toast.create(
          "layout-toast",
          "Saved",
          "Action redirects to this anatomy page.",
          :success,
          id: "toast-anatomy-redirect",
          duration: 30_000,
          action: %{
            label: "Same page",
            class: "button ui-accent ui-size-sm",
            js: JS.patch(~p"/toast/anatomy")
          }
        )
      }
      class="button ui-size-sm"
    >
      Toast with redirect
    </.action>
    """
  end

  def anatomy_trigger_live_view_js_code do
    ~S"""
    <.action
      phx-click={
        Corex.Toast.create("layout-toast", "Dismiss me", "Action runs a Phoenix.LiveView.JS command.", :info,
          id: "toast-anatomy-dismiss",
          duration: :infinity,
          action: %{
            label: "Dismiss",
            class: "button ui-accent ui-size-sm",
            js: Corex.Toast.dismiss("layout-toast", "toast-anatomy-dismiss")
          }
        )
      }
      class="button ui-size-sm"
    >
      Toast with Live View JS
    </.action>
    """
  end

  def anatomy_trigger_live_view_js_example(assigns) do
    ~H"""
    <.action
      phx-click={
        Corex.Toast.create(
          "layout-toast",
          "Dismiss me",
          "Action runs a Phoenix.LiveView.JS command.",
          :info,
          id: "toast-anatomy-dismiss",
          duration: :infinity,
          action: %{
            label: "Dismiss",
            class: "button ui-accent ui-size-sm",
            js: Corex.Toast.dismiss("layout-toast", "toast-anatomy-dismiss")
          }
        )
      }
      class="button ui-size-sm"
    >
      Toast with Live View JS
    </.action>
    """
  end

  def anatomy_trigger_custom_label_code do
    ~S"""
    <.action
      phx-click={
        Corex.Toast.create("layout-toast", "Open docs", "Label is rendered from ~H with a heroicon.", :info,
          id: "toast-anatomy-custom-label",
          duration: 30_000,
          action: %{
            label: ~H{
              <.heroicon name="hero-arrow-top-right-on-square" />
              Open
            },
            class: "button ui-accent ui-size-sm",
            js: JS.patch(~p"/toast/anatomy")
          }
        )
      }
      class="button ui-size-sm"
    >
      Toast with custom label
    </.action>
    """
  end

  def anatomy_trigger_custom_label_example(assigns) do
    ~H"""
    <.action
      phx-click={
        Corex.Toast.create(
          "layout-toast",
          "Open docs",
          "Label is rendered from ~H with a heroicon.",
          :info,
          id: "toast-anatomy-custom-label",
          duration: 30_000,
          action: %{
            label: ~H{
              <.heroicon name="hero-arrow-top-right-on-square" />
              Open
            },
            class: "button ui-accent ui-size-sm",
            js: JS.patch(~p"/toast/anatomy")
          }
        )
      }
      class="button ui-size-sm"
    >
      Toast with custom label
    </.action>
    """
  end

  def api_codes do
    %{
      create_client_binding: api_client_binding_code(),
      create_client_js_heex: api_create_client_js_heex(),
      create_client_js: api_create_client_js(),
      create_client_ts: api_create_client_ts(),
      update_toast_client_binding: api_update_toast_client_binding_code(),
      update_toast_client_js_heex: api_update_toast_client_js_heex(),
      update_toast_client_js: api_update_toast_client_js(),
      update_toast_client_ts: api_update_toast_client_ts(),
      create_server_heex: api_create_server_heex(),
      create_server_elixir: api_create_server_elixir(),
      update_toast_server_heex: api_update_toast_server_heex(),
      update_toast_server_elixir: api_update_toast_server_elixir()
    }
  end
end
