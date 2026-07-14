defmodule E2eWeb.Demos.CollapsibleDemo do
  use E2eWeb, :html

  alias E2eWeb.DemoScales

  def anatomy_basic_code do
    ~S"""
    <.collapsible class="collapsible">
      <:trigger>Toggle</:trigger>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <.collapsible id="collapsible-anatomy" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def with_indicator_code do
    ~S"""
    <.collapsible class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def with_indicator_example(assigns) do
    ~H"""
    <.collapsible id="collapsible-anatomy-indicator" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def custom_slots_code do
    ~S"""
    <.collapsible class="collapsible">
      <:trigger :let={c}>
        {if c.open, do: "Collapse", else: "Expand"}
      </:trigger>
      <:closed>
        <.heroicon name="hero-chevron-down" />
      </:closed>
      <:opened>
        <.heroicon name="hero-chevron-up" />
      </:opened>
      <:content :let={_c}>
        Panel body with custom opened/closed adornments.
      </:content>
    </.collapsible>
    """
  end

  def custom_slots_example(assigns) do
    ~H"""
    <.collapsible id="collapsible-anatomy-custom" class="collapsible">
      <:trigger :let={c}>
        {if c.open, do: "Collapse", else: "Expand"}
      </:trigger>
      <:closed>
        <.heroicon name="hero-chevron-down" />
      </:closed>
      <:opened>
        <.heroicon name="hero-chevron-up" />
      </:opened>
      <:content :let={_c}>
        Panel body with custom opened/closed adornments.
      </:content>
    </.collapsible>
    """
  end

  def api_client_binding_code do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click={Corex.Collapsible.set_open("collapsible-api", true)} class="button ui-size-sm">
        Open
      </.action>
      <.action phx-click={Corex.Collapsible.set_open("collapsible-api", false)} class="button ui-size-sm">
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def api_client_binding_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={Corex.Collapsible.set_open("collapsible-api", true)}
        class="button ui-size-sm"
      >
        Open
      </.action>
      <.action
        phx-click={Corex.Collapsible.set_open("collapsible-api", false)}
        class="button ui-size-sm"
      >
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def api_client_js_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:collapsible:set-open",
            to: "#collapsible-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Open
      </.action>
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:collapsible:set-open",
            to: "#collapsible-api-js",
            detail: %{open: false},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api-js" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def api_client_js_js do
    ~S"""
    const el = document.getElementById("collapsible-api-js");
    el?.dispatchEvent(
      new CustomEvent("corex:collapsible:set-open", { bubbles: false, detail: { open: true } })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:collapsible:set-open", { bubbles: false, detail: { open: false } })
    );
    """
  end

  def api_client_js_ts do
    ~S"""
    const el: HTMLElement | null = document.getElementById("collapsible-api-js");
    el?.dispatchEvent(
      new CustomEvent("corex:collapsible:set-open", { bubbles: false, detail: { open: true } })
    );
    el?.dispatchEvent(
      new CustomEvent("corex:collapsible:set-open", { bubbles: false, detail: { open: false } })
    );
    """
  end

  def api_client_js_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:collapsible:set-open",
            to: "#collapsible-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Open
      </.action>
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:collapsible:set-open",
            to: "#collapsible-api-js",
            detail: %{open: false},
            bubbles: false
          )
        }
        class="button ui-size-sm"
      >
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api-js" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def api_server_heex do
    ~S"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="collapsible_api_open" class="button ui-size-sm">Open</.action>
      <.action phx-click="collapsible_api_close" class="button ui-size-sm">Close</.action>
    </div>

    <.collapsible id="collapsible-api-server" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def api_server_elixir do
    ~S"""
    def handle_event("collapsible_api_open", _, socket) do
      {:noreply, Corex.Collapsible.set_open(socket, "collapsible-api-server", true)}
    end

    def handle_event("collapsible_api_close", _, socket) do
      {:noreply, Corex.Collapsible.set_open(socket, "collapsible-api-server", false)}
    end
    """
  end

  def api_server_example(assigns) do
    ~H"""
    <div class="flex flex-wrap items-center gap-space">
      <.action phx-click="collapsible_api_open" class="button ui-size-sm">Open</.action>
      <.action phx-click="collapsible_api_close" class="button ui-size-sm">Close</.action>
    </div>

    <.collapsible id="collapsible-api-server" class="collapsible">
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def events_server_heex do
    ~S"""
    <.collapsible
      class="collapsible"
      on_open_change="collapsible_open_changed"
    >
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>Lorem ipsum dolor sit amet.</:content>
    </.collapsible>
    """
  end

  def events_server_elixir do
    E2eWeb.Demos.DocExamples.event_handler_snippet(
      "collapsible_open_changed",
      ~S|%{"id" => id, "open" => open} = params|
    )
  end

  def events_client_heex do
    ~S"""
    <.collapsible
      id="collapsible-events-client"
      class="collapsible"
      on_open_change_client="collapsible-open-changed"
    >
      <:trigger>Toggle</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>Lorem ipsum dolor sit amet.</:content>
    </.collapsible>
    """
  end

  def events_client_js do
    ~S"""
    const el = document.getElementById("collapsible-events-client");
    el?.addEventListener("collapsible-open-changed", (event) => console.log(event.detail));
    """
  end

  def events_client_ts do
    ~S"""
    const el = document.getElementById("collapsible-events-client");
    el?.addEventListener("collapsible-open-changed", (event: Event) =>
      console.log((event as CustomEvent<unknown>).detail)
    );
    """
  end

  def styling_color_code do
    ~S"""
    <.collapsible class="collapsible ui-size-md">
      <:trigger>Default width</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible class="collapsible ui-size-md ui-accent">
      <:trigger>Accent trigger</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible class="collapsible ui-size-md ui-brand">
      <:trigger>Brand trigger</:trigger>
      <:content>Content</:content>
    </.collapsible>
    """
  end

  def styling_color_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-xl">
      <.collapsible id="collapsible-style-default" class="collapsible ui-size-md">
        <:trigger>Default width</:trigger>
        <:content>Content</:content>
      </.collapsible>
      <.collapsible
        id="collapsible-style-accent"
        class="collapsible ui-size-md ui-accent"
      >
        <:trigger>Accent trigger</:trigger>
        <:content>Content</:content>
      </.collapsible>
      <.collapsible
        id="collapsible-style-brand"
        class="collapsible ui-size-md ui-brand"
      >
        <:trigger>Brand trigger</:trigger>
        <:content>Content</:content>
      </.collapsible>
    </div>
    """
  end

  def styling_variant_code do
    ~S"""
    <.collapsible class="collapsible ui-size-md">
      <:trigger>Subtle (default)</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible class="collapsible ui-solid ui-size-md">
      <:trigger>Solid</:trigger>
      <:content>Content</:content>
    </.collapsible>

    """
  end

  def styling_variant_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-xl">
      <.collapsible id="collapsible-style-variant-subtle" class="collapsible ui-size-md">
        <:trigger>Subtle (default)</:trigger>
        <:content>Content</:content>
      </.collapsible>
      <.collapsible
        id="collapsible-style-variant-solid"
        class="collapsible ui-solid ui-size-md"
      >
        <:trigger>Solid</:trigger>
        <:content>Content</:content>
      </.collapsible>
    </div>
    """
  end

  def styling_variant_matrix_code do
    for semantic <- DemoScales.styling_semantic_axis_steps("collapsible"),
        variant <- DemoScales.styling_variant_axis_steps("collapsible") do
      class = DemoScales.join_matrix_modifiers("collapsible", semantic.modifier, variant.modifier)

      ~s(<.collapsible class="#{class} ui-size-md">
        <:trigger>#{semantic.label}</:trigger>
        <:content>Content</:content>
      </.collapsible>)
    end
    |> DemoScales.join_code()
  end

  def styling_variant_matrix_example(assigns) do
    assigns =
      assigns
      |> assign(:matrix_semantics, DemoScales.styling_semantic_axis_steps("collapsible"))
      |> assign(:matrix_variants, DemoScales.styling_variant_axis_steps("collapsible"))

    ~H"""
    <div class="w-full overflow-x-auto scrollbar scrollbar--sm">
      <div class="grid grid-cols-4 gap-space items-start min-w-max">
        <div :for={semantic <- @matrix_semantics} class="contents">
          <.collapsible
            :for={variant <- @matrix_variants}
            class={DemoScales.join_matrix_modifiers("collapsible", semantic.modifier, variant.modifier) <> " ui-size-md"}
          >
            <:trigger>{semantic.label}</:trigger>
            <:content>Content</:content>
          </.collapsible>
        </div>
      </div>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.collapsible class="collapsible ui-size-sm">
      <:trigger>Small</:trigger>
      <:content><p>Content</p></:content>
    </.collapsible>
    <.collapsible class="collapsible ui-size-md">
      <:trigger>Medium</:trigger>
      <:content><p>Content</p></:content>
    </.collapsible>
    <.collapsible class="collapsible ui-size-lg">
      <:trigger>Large</:trigger>
      <:content><p>Content</p></:content>
    </.collapsible>
    <.collapsible class="collapsible ui-size-xl">
      <:trigger>Extra large</:trigger>
      <:content><p>Content</p></:content>
    </.collapsible>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full">
      <.collapsible id="collapsible-style-sm" class="collapsible ui-size-sm">
        <:trigger>Small</:trigger>
        <:content>
          <p>Content</p>
        </:content>
      </.collapsible>
      <.collapsible id="collapsible-style-md" class="collapsible ui-size-md">
        <:trigger>Medium</:trigger>
        <:content>
          <p>Content</p>
        </:content>
      </.collapsible>
      <.collapsible id="collapsible-style-lg" class="collapsible ui-size-lg">
        <:trigger>Large</:trigger>
        <:content>
          <p>Content</p>
        </:content>
      </.collapsible>
      <.collapsible id="collapsible-style-xl" class="collapsible ui-size-xl">
        <:trigger>Extra large</:trigger>
        <:content>
          <p>Content</p>
        </:content>
      </.collapsible>
    </div>
    """
  end

  def styling_max_width_code do
    DemoScales.max_width_variants("collapsible")
    |> Enum.map(fn %{id: id, modifier: modifier} ->
      class = DemoScales.join_modifiers("collapsible", modifier)

      """
      <.collapsible id="collapsible-style-max-#{id}" class="#{class}">
        <:trigger>#{id}</:trigger>
        <:content>Content</:content>
      </.collapsible>
      """
    end)
    |> DemoScales.join_code()
  end

  def styling_max_width_example(assigns) do
    assigns = assign(assigns, :max_width_variants, DemoScales.max_width_variants("collapsible"))

    ~H"""
    <div class={DemoScales.preview_scroll_class()}>
      <div :for={variant <- @max_width_variants} class="flex flex-col gap-2">
        <p class="typo ui-size-sm font-medium">{variant.label}</p>
        <.collapsible
          id={"collapsible-style-max-#{variant.id}"}
          class={DemoScales.join_modifiers("collapsible", variant.modifier)}
        >
          <:trigger>{variant.label}</:trigger>
          <:content>Content</:content>
        </.collapsible>
      </div>
    </div>
    """
  end

  def patterns_async_heex_full do
    ~S"""
    <.async_result :let={panel} assign={@collapsible}>
      <:loading>
        <.collapsible_skeleton class="collapsible" />
      </:loading>

      <.collapsible
        class="collapsible"
        open={panel.open}
      >
        <:trigger>Details</:trigger>
        <:closed>
          <.heroicon name="hero-chevron-right" />
        </:closed>
        <:content>
          {panel.body}
        </:content>
      </.collapsible>
    </.async_result>
    """
  end

  def patterns_async_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok,
       socket
       |> assign_async(:collapsible, fn ->
         Process.sleep(1000)
         {:ok, %{collapsible: %{open: false, body: "Loaded after async."}}}
       end)}
    end
    """
  end

  def patterns_controlled_heex do
    ~S"""
    <.collapsible
      class="collapsible"
      controlled
      open={@open}
      on_open_change="patterns_collapsible_changed"
    >
      <:trigger>Controlled</:trigger>
      <:closed>
        <.heroicon name="hero-chevron-right" />
      </:closed>
      <:content>LiveView owns open.</:content>
    </.collapsible>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def handle_event("patterns_collapsible_changed", %{"open" => open}, socket) do
      {:noreply, assign(socket, :open, open)}
    end
    """
  end
end
