defmodule E2eWeb.Demos.ToggleDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  import E2eWeb.ModeToggle

  def minimal_code do
    ~S"""
    <.toggle class="toggle">
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
    <.toggle class="toggle">
      <:indicator><.heroicon name="hero-bold" /></:indicator>
      Bold
    </.toggle>

    <.toggle class="toggle">
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
    <.toggle class="toggle" data-toggle-dual-label>
      <span>lorem</span>
      <span data-pressed>donec</span>
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
    <.toggle class="toggle">Default</.toggle>
    <.toggle class="toggle ui-accent">Accent</.toggle>
    <.toggle class="toggle ui-brand">Brand</.toggle>
    <.toggle class="toggle ui-alert">Alert</.toggle>
    <.toggle class="toggle ui-info">Info</.toggle>
    <.toggle class="toggle ui-success">Success</.toggle>
    """
  end

  def styling_color_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-c-default" class="toggle">Default</.toggle>
      <.toggle id="toggle-style-c-accent" class="toggle ui-accent">Accent</.toggle>
      <.toggle id="toggle-style-c-brand" class="toggle ui-brand">Brand</.toggle>
      <.toggle id="toggle-style-c-alert" class="toggle ui-alert">Alert</.toggle>
      <.toggle id="toggle-style-c-info" class="toggle ui-info">Info</.toggle>
      <.toggle id="toggle-style-c-success" class="toggle ui-success">Success</.toggle>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.toggle class="toggle">Subtle (default)</.toggle>
    <.toggle class="toggle ui-solid">Solid</.toggle>
    """
  end

  def styling_variant_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-variant-subtle" class="toggle">Subtle (default)</.toggle>
      <.toggle id="toggle-style-variant-solid" class="toggle ui-solid">Solid</.toggle>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("toggle"),
        variant <- DemoScales.styling_variant_axis_steps("toggle") do
      class = DemoScales.join_matrix_modifiers("toggle", semantic.modifier, variant.modifier)

      ~s(<.toggle class="#{class}">#{semantic.label}</.toggle>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("toggle"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("toggle"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space gap-2 items-center min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.toggle
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("toggle", semantic.modifier, variant.modifier)}
          >
            {semantic.label}
          </.toggle>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.toggle class="toggle ui-size-sm" pressed>SM</.toggle>
    <.toggle class="toggle ui-size-md" pressed>MD</.toggle>
    <.toggle class="toggle ui-size-lg" pressed>LG</.toggle>
    <.toggle class="toggle ui-size-xl" pressed>XL</.toggle>
    """
  end

  def styling_size_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-6 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-sm" class="toggle ui-size-sm" pressed>SM</.toggle>
      <.toggle id="toggle-style-md" class="toggle ui-size-md" pressed>MD</.toggle>
      <.toggle id="toggle-style-lg" class="toggle ui-size-lg" pressed>LG</.toggle>
      <.toggle id="toggle-style-xl" class="toggle ui-size-xl" pressed>XL</.toggle>
    </div>
    """
  end

  def styling_radius_code do
    ~S"""
    <.toggle class="toggle ui-rounded-none" pressed>None</.toggle>
    <.toggle class="toggle ui-rounded-sm" pressed>SM</.toggle>
    <.toggle class="toggle ui-rounded-md" pressed>MD</.toggle>
    <.toggle class="toggle ui-rounded-lg" pressed>LG</.toggle>
    <.toggle class="toggle ui-rounded-xl" pressed>XL</.toggle>
    <.toggle class="toggle ui-rounded-full" pressed>Full</.toggle>
    """
  end

  def styling_radius_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-radius-none" class="toggle ui-rounded-none" pressed>
        None
      </.toggle>
      <.toggle id="toggle-style-radius-sm" class="toggle ui-rounded-sm" pressed>SM</.toggle>
      <.toggle id="toggle-style-radius-md" class="toggle ui-rounded-md" pressed>MD</.toggle>
      <.toggle id="toggle-style-radius-lg" class="toggle ui-rounded-lg" pressed>LG</.toggle>
      <.toggle id="toggle-style-radius-xl" class="toggle ui-rounded-xl" pressed>XL</.toggle>
      <.toggle id="toggle-style-radius-full" class="toggle ui-rounded-full" pressed>
        Full
      </.toggle>
    </div>
    """
  end

  def styling_width_code do
    label = DemoScales.block_demo_label()

    DemoScales.width_layout_variants("toggle")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_modifiers("toggle", modifier)

      """
      <.toggle class="#{class}" pressed>#{label}</.toggle>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_code do
    label = DemoScales.block_demo_label()

    DemoScales.max_width_variants("toggle")
    |> Enum.map(fn %{modifier: modifier} ->
      class = DemoScales.join_block_modifiers("toggle", modifier)

      """
      <.toggle class="#{class}" pressed>#{label}</.toggle>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_width_example(assigns) do
    assigns = assign(assigns, :width_variants, DemoScales.width_layout_variants("toggle"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.toggle
          id={"toggle-style-width-#{variant.id}"}
          class={DemoScales.join_modifiers("toggle", variant.modifier)}
          pressed
        >
          {DemoScales.block_demo_label()}
        </.toggle>
      </div>
    </div>
    """
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("toggle"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.toggle
          id={"toggle-style-max-#{variant.id}"}
          class={DemoScales.join_block_modifiers("toggle", variant.modifier)}
          pressed
        >
          {DemoScales.block_demo_label()}
        </.toggle>
      </div>
    </div>
    """
  end

  def styling_disabled_code do
    ~S"""
    <.toggle class="toggle" disabled>Disabled</.toggle>
    <.toggle class="toggle ui-accent" pressed disabled>
      Disabled
    </.toggle>
    """
  end

  def styling_disabled_example(assigns) do
    _ = assigns

    ~H"""
    <div class="flex flex-wrap gap-4 items-center w-full max-w-4xl">
      <.toggle id="toggle-style-disabled-off" class="toggle" disabled>Disabled</.toggle>
      <.toggle id="toggle-style-disabled-on" class="toggle ui-accent" pressed disabled>
        Disabled
      </.toggle>
    </div>
    """
  end

  def api_server_heex do
    ~S"""
    <.action class="button ui-size-sm" phx-click="toggle_api_on">Pressed</.action>
    <.action class="button ui-size-sm" phx-click="toggle_api_off">Not pressed</.action>
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
    <.action class="button ui-size-sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", true)}>
      Pressed
    </.action>
    <.action class="button ui-size-sm" phx-click={Corex.Toggle.set_pressed("toggle-api-bind", false)}>
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
      class="button ui-size-sm"
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
      class="button ui-size-sm"
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
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "toggle_pressed_changed",
      ~S|%{"pressed" => pressed} = params|
    )
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
