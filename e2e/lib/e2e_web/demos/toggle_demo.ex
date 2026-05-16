defmodule E2eWeb.Demos.ToggleDemo do
  use E2eWeb, :html

  import E2eWeb.ModeToggle

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
    <.toggle id="toggle-anatomy-indicator-label" class="toggle">
      <:indicator><.heroicon name="hero-bold" /></:indicator>
      Bold
    </.toggle>

    <.toggle id="toggle-anatomy-indicator-sr" class="toggle">
      <:indicator><.heroicon name="hero-bold" /></:indicator>
      <span class="sr-only">Bold</span>
    </.toggle>
    """
  end

  def with_indicator_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-4 items-center justify-center">
      <.toggle id="toggle-anatomy-indicator-label" class="toggle">
        <:indicator><.heroicon name="hero-bold" /></:indicator>
        Bold
      </.toggle>
      <.toggle id="toggle-anatomy-indicator-sr" class="toggle">
        <:indicator><.heroicon name="hero-bold" /></:indicator>
        <span class="sr-only">Bold</span>
      </.toggle>
    </div>
    """
  end

  def dual_label_code do
    ~S"""
    <.toggle id="toggle-anatomy-switching-label" class="toggle" data-toggle-dual-label>
      <span>lorem</span>
      <span data-pressed>donec</span>
    </.toggle>

    <.toggle
      id="mode-switcher"
      class="toggle toggle--sm"
      data-toggle-dual-label
      pressed={@mode == "dark"}
      on_pressed_change_client="phx:set-mode"
    >
      <span>
        <.heroicon name="hero-moon" />
      </span>
      <span data-pressed>
        <.heroicon name="hero-sun" />
      </span>
    </.toggle>
    """
  end

  def dual_label_example(assigns) do
    assigns = assign_new(assigns, :mode, fn -> "light" end)

    ~H"""
    <div class="flex flex-wrap gap-6 items-center justify-center">
      <.toggle id="toggle-anatomy-switching-label" class="toggle" data-toggle-dual-label>
        <span>lorem</span>
        <span data-pressed>donec</span>
      </.toggle>
      <.mode_toggle id="toggle-anatomy-mode" mode={@mode} />
    </div>
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.toggle
      id="toggle-patterns-controlled"
      class="toggle"
      controlled
      pressed={@pressed}
      on_pressed_change="toggle_patterns_pressed"
    >
      lorem
    </.toggle>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :pressed, false)}
    end

    def handle_event("toggle_patterns_pressed", %{"pressed" => pressed}, socket) do
      {:noreply, assign(socket, :pressed, pressed == true or pressed == "true")}
    end
    """
  end

  def styling_color_code do
    ~S"""
    <.toggle id="toggle-style-c-default" class="toggle">Default</.toggle>
    <.toggle id="toggle-style-c-accent" class="toggle toggle--accent">Accent</.toggle>
    <.toggle id="toggle-style-c-brand" class="toggle toggle--brand">Brand</.toggle>
    <.toggle id="toggle-style-c-alert" class="toggle toggle--alert">Alert</.toggle>
    <.toggle id="toggle-style-c-info" class="toggle toggle--info">Info</.toggle>
    <.toggle id="toggle-style-c-success" class="toggle toggle--success">Success</.toggle>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-c-default" class="toggle">Default</.toggle>
      <.toggle id="toggle-style-c-accent" class="toggle toggle--accent">Accent</.toggle>
      <.toggle id="toggle-style-c-brand" class="toggle toggle--brand">Brand</.toggle>
      <.toggle id="toggle-style-c-alert" class="toggle toggle--alert">Alert</.toggle>
      <.toggle id="toggle-style-c-info" class="toggle toggle--info">Info</.toggle>
      <.toggle id="toggle-style-c-success" class="toggle toggle--success">Success</.toggle>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.toggle id="toggle-style-sm" class="toggle toggle--sm" pressed>SM</.toggle>
    <.toggle id="toggle-style-md" class="toggle toggle--md" pressed>MD</.toggle>
    <.toggle id="toggle-style-lg" class="toggle toggle--lg" pressed>LG</.toggle>
    <.toggle id="toggle-style-xl" class="toggle toggle--xl" pressed>XL</.toggle>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-sm" class="toggle toggle--sm" pressed>SM</.toggle>
      <.toggle id="toggle-style-md" class="toggle toggle--md" pressed>MD</.toggle>
      <.toggle id="toggle-style-lg" class="toggle toggle--lg" pressed>LG</.toggle>
      <.toggle id="toggle-style-xl" class="toggle toggle--xl" pressed>XL</.toggle>
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.toggle id="toggle-style-radius-none" class="toggle toggle--rounded-none" pressed>None</.toggle>
    <.toggle id="toggle-style-radius-sm" class="toggle toggle--rounded-sm" pressed>SM</.toggle>
    <.toggle id="toggle-style-radius-md" class="toggle toggle--rounded-md" pressed>MD</.toggle>
    <.toggle id="toggle-style-radius-lg" class="toggle toggle--rounded-lg" pressed>LG</.toggle>
    <.toggle id="toggle-style-radius-xl" class="toggle toggle--rounded-xl" pressed>XL</.toggle>
    <.toggle id="toggle-style-radius-full" class="toggle toggle--rounded-full" pressed>Full</.toggle>
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-radius-none" class="toggle toggle--rounded-none" pressed>
        None
      </.toggle>
      <.toggle id="toggle-style-radius-sm" class="toggle toggle--rounded-sm" pressed>SM</.toggle>
      <.toggle id="toggle-style-radius-md" class="toggle toggle--rounded-md" pressed>MD</.toggle>
      <.toggle id="toggle-style-radius-lg" class="toggle toggle--rounded-lg" pressed>LG</.toggle>
      <.toggle id="toggle-style-radius-xl" class="toggle toggle--rounded-xl" pressed>XL</.toggle>
      <.toggle id="toggle-style-radius-full" class="toggle toggle--rounded-full" pressed>
        Full
      </.toggle>
    </div>
    """
  end

  def styling_disabled_code do
    ~S"""
    <.toggle id="toggle-style-disabled-off" class="toggle" disabled>Disabled</.toggle>
    <.toggle id="toggle-style-disabled-on" class="toggle toggle--accent" pressed disabled>
      Disabled
    </.toggle>
    """
  end

  def styling_disabled_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-disabled-off" class="toggle" disabled>Disabled</.toggle>
      <.toggle id="toggle-style-disabled-on" class="toggle toggle--accent" pressed disabled>
        Disabled
      </.toggle>
    </div>
    """
  end

  def api_server_heex do
    ~S"""
    <.action class="button button--sm" phx-click="toggle_api_on">Pressed</.action>
    <.action class="button button--sm" phx-click="toggle_api_off">Not pressed</.action>
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
      Pressed
    </.action>
    <.action class="button button--sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", false)}>
      Not pressed
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
          detail: %{pressed: true},
          bubbles: false
        )
      }
    >
      Pressed
    </.action>
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
      Not pressed
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
