defmodule E2eWeb.Demos.ToggleDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  import E2eWeb.ModeToggle

  def minimal_code do
    ~S"""
    <.toggle >
      lorem
    </.toggle>
    """
  end

  def minimal_example(assigns) do
    ~H"""
    <.toggle id="toggle-anatomy-minimal">
      lorem
    </.toggle>
    """
  end

  def with_indicator_code do
    ~S"""
    <.toggle >
      <:indicator><.heroicon name="hero-bold" /></:indicator>
      Bold
    </.toggle>

    <.toggle >
      <:indicator><.heroicon name="hero-bold" /></:indicator>
      <span class="sr-only">Bold</span>
    </.toggle>
    """
  end

  def with_indicator_example(assigns) do
    ~H"""
    <div class="flex flex-wrap gap-4 items-center justify-center">
      <.toggle id="toggle-anatomy-indicator-label">
        <:indicator><.heroicon name="hero-bold" /></:indicator>
        Bold
      </.toggle>
      <.toggle id="toggle-anatomy-indicator-sr">
        <:indicator><.heroicon name="hero-bold" /></:indicator>
        <span class="sr-only">Bold</span>
      </.toggle>
    </div>
    """
  end

  def dual_label_code do
    ~S"""
    <.toggle  data-toggle-dual-label>
      <span>lorem</span>
      <span data-pressed>donec</span>
    </.toggle>
    """
  end

  def dual_label_example(assigns) do
    assigns = assign_new(assigns, :mode, fn -> "light" end)

    ~H"""
    <div class="flex flex-wrap gap-6 items-center justify-center">
      <.toggle id="toggle-anatomy-switching-label" data-toggle-dual-label>
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

  def styling_semantic_code do
    ~S"""
    <.toggle >Default</.toggle>
    <.toggle semantic="accent">Accent</.toggle>
    <.toggle semantic="brand">Brand</.toggle>
    <.toggle semantic="alert">Alert</.toggle>
    <.toggle semantic="info">Info</.toggle>
    <.toggle semantic="success">Success</.toggle>
    """
  end

  def styling_semantic_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-c-default">Default</.toggle>
      <.toggle id="toggle-style-c-accent" semantic="accent">Accent</.toggle>
      <.toggle id="toggle-style-c-brand" semantic="brand">Brand</.toggle>
      <.toggle id="toggle-style-c-alert" semantic="alert">Alert</.toggle>
      <.toggle id="toggle-style-c-info" semantic="info">Info</.toggle>
      <.toggle id="toggle-style-c-success" semantic="success">Success</.toggle>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.toggle size="sm" pressed>SM</.toggle>
    <.toggle size="md" pressed>MD</.toggle>
    <.toggle size="lg" pressed>LG</.toggle>
    <.toggle size="xl" pressed>XL</.toggle>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-sm" size="sm" pressed>SM</.toggle>
      <.toggle id="toggle-style-md" size="md" pressed>MD</.toggle>
      <.toggle id="toggle-style-lg" size="lg" pressed>LG</.toggle>
      <.toggle id="toggle-style-xl" size="xl" pressed>XL</.toggle>
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.toggle  class="toggle toggle--rounded-none" pressed>None</.toggle>
    <.toggle  class="toggle toggle--rounded-sm" pressed>SM</.toggle>
    <.toggle  class="toggle toggle--rounded-md" pressed>MD</.toggle>
    <.toggle  class="toggle toggle--rounded-lg" pressed>LG</.toggle>
    <.toggle  class="toggle toggle--rounded-xl" pressed>XL</.toggle>
    <.toggle  class="toggle toggle--rounded-full" pressed>Full</.toggle>
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
    <.toggle  disabled>Disabled</.toggle>
    <.toggle semantic="accent" pressed disabled>
      Disabled
    </.toggle>
    """
  end

  def styling_disabled_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-disabled-off" disabled>Disabled</.toggle>
      <.toggle id="toggle-style-disabled-on" semantic="accent" pressed disabled>
        Disabled
      </.toggle>
    </div>
    """
  end

  def api_server_heex do
    ~S"""
    <.action size="sm" phx-click="toggle_api_on">Pressed</.action>
    <.action size="sm" phx-click="toggle_api_off">Not pressed</.action>
    <.toggle id="toggle-api-srv"  controlled pressed={@api_srv_pressed}>
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
    <.action size="sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", true)}>
      Pressed
    </.action>
    <.action size="sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", false)}>
      Not pressed
    </.action>
    <.toggle id="toggle-api-bind"  controlled pressed={false}>
      duis
    </.toggle>
    """
  end

  def api_client_js_heex do
    ~S"""
    <.action
      size="sm"
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
      size="sm"
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
    <.toggle id="toggle-api-cjs"  pressed>
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
    const el: HTMLElement | null = document.getElementById("toggle-api-cjs");
    el?.dispatchEvent(
      new CustomEvent<{ pressed: boolean }>("corex:toggle:set-pressed", {
        bubbles: false,
        detail: { pressed: true },
      })
    );
    """
  end

  def events_server_heex do
    ~S"""
    <.toggle
      
      controlled
      pressed={false}
      on_pressed_change="toggle_pressed_changed"
    >
      lorem
    </.toggle>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "toggle_pressed_changed",
      ~S|%{"pressed" => pressed} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.toggle
      id="toggle-on-pressed-change-client"
      
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
