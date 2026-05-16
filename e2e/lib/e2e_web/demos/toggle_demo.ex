defmodule E2eWeb.Demos.ToggleDemo do
  use E2eWeb, :html

  def minimal_code do
    ~S"""
    <.toggle id="toggle-anatomy-minimal" class="toggle">
      lorem
    </.toggle>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.toggle id="toggle-anatomy-minimal" class="toggle">
      lorem
    </.toggle>
    """
  end

  def with_indicator_code do
    ~S"""
    <.toggle id="toggle-anatomy-indicator" class="toggle">
      <:indicator>duis</:indicator>
      lorem
    </.toggle>
    """
  end

  def with_indicator_example(assigns) do
    ~H"""
    <.toggle id="toggle-anatomy-indicator" class="toggle">
      <:indicator>duis</:indicator>
      lorem
    </.toggle>
    """
  end

  def dual_label_code do
    ~S"""
    <.toggle id="toggle-anatomy-dual-label" class="toggle group">
      <span class="hidden group-data-[pressed=false]:inline">lorem</span>
      <span class="hidden group-data-[pressed=true]:inline">donec</span>
    </.toggle>
    """
  end

  def dual_label_example(assigns) do
    ~H"""
    <.toggle id="toggle-anatomy-dual-label" class="toggle group">
      <span class="hidden group-data-[pressed=false]:inline">lorem</span>
      <span class="hidden group-data-[pressed=true]:inline">donec</span>
    </.toggle>
    """
  end

  def styling_size_code do
    ~S"""
    <.toggle id="toggle-style-sm" class="toggle toggle--sm" pressed>lorem</.toggle>
    <.toggle id="toggle-style-md" class="toggle toggle--md" pressed>duis</.toggle>
    <.toggle id="toggle-style-lg" class="toggle toggle--lg" pressed>donec</.toggle>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-sm" class="toggle toggle--sm" pressed>lorem</.toggle>
      <.toggle id="toggle-style-md" class="toggle toggle--md" pressed>duis</.toggle>
      <.toggle id="toggle-style-lg" class="toggle toggle--lg" pressed>donec</.toggle>
    </div>
    """
  end

  def api_server_heex do
    ~S"""
    <.action class="button button--sm" phx-click="toggle_api_on">donec</.action>
    <.action class="button button--sm" phx-click="toggle_api_off">lorem</.action>
    <.toggle id="toggle-api-srv" class="toggle" controlled pressed={@api_srv_pressed}>
      duis
    </.toggle>
    """
  end

  def api_server_elixir do
    ~S"""
    def handle_event("toggle_api_on", _, socket) do
      {:noreply, Corex.Toggle.set_pressed(socket, "toggle-api-srv", true)}
    end

    def handle_event("toggle_api_off", _, socket) do
      {:noreply, Corex.Toggle.set_pressed(socket, "toggle-api-srv", false)}
    end
    """
  end

  def api_client_binding_heex do
    ~S"""
    <.action class="button button--sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", true)}>
      donec
    </.action>
    <.action class="button button--sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", false)}>
      lorem
    </.action>
    <.toggle id="toggle-api-bind" class="toggle" controlled pressed={false}>
      duis
    </.toggle>
    """
  end

  def api_client_js_heex do
    ~S"""
    <.action
      class="button button--sm"
      phx-click={
        Phoenix.LiveView.JS.dispatch("corex:toggle:set-pressed",
          to: "#toggle-api-cjs",
          detail: %{pressed: false},
          bubbles: false
        )
      }
    >
      lorem
    </.action>
    <.toggle id="toggle-api-cjs" class="toggle" pressed>
      duis
    </.toggle>
    """
  end

  def api_client_js_js do
    ~S"""
    const el = document.getElementById("toggle-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:toggle:set-pressed", {
        bubbles: false,
        detail: { pressed: true },
      })
    );
    """
  end

  def api_client_js_ts do
    ~S"""
    const el = document.getElementById("toggle-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:toggle:set-pressed", {
        bubbles: false,
        detail: { pressed: true },
      })
    );
    """
  end

  def events_server_heex do
    ~S"""
    <.toggle
      id="toggle-on-pressed-change-server"
      class="toggle"
      controlled
      pressed={false}
      on_pressed_change="toggle_pressed_changed"
    >
      lorem
    </.toggle>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("toggle_pressed_changed", %{"pressed" => pressed}, socket) do
      p = pressed == true or pressed == "true"
      {:noreply, assign(socket, :pressed, p)}
    end
    """
  end

  def events_client_heex do
    ~S"""
    <.toggle
      id="toggle-on-pressed-change-client"
      class="toggle"
      on_pressed_change_client="toggle-client-changed"
    >
      lorem
    </.toggle>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("toggle-on-pressed-change-client");
    el?.addEventListener("toggle-client-changed", (e) => console.log(e.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("toggle-on-pressed-change-client");
    el?.addEventListener("toggle-client-changed", (e: Event) =>
      console.log((e as CustomEvent).detail)
    );
    """
  end
end
