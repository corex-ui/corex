defmodule E2eWeb.Demos.CollapsibleDemo do
  use E2eWeb, :html

  alias E2eWeb.Demos.StylingAxes

  def styling_axis_values(axis), do: StylingAxes.styling_axis_values(axis)

  def anatomy_basic_code do
    ~S"""
    <.collapsible >
      <:trigger>Toggle</:trigger>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def anatomy_basic_example(assigns) do
    ~H"""
    <.collapsible id="collapsible-anatomy">
      <:trigger>Toggle</:trigger>
      <:content>
        Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      </:content>
    </.collapsible>
    """
  end

  def with_indicator_code do
    ~S"""
    <.collapsible >
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
    <.collapsible id="collapsible-anatomy-indicator">
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
    <.collapsible >
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
    <.collapsible id="collapsible-anatomy-custom">
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
    <div class="layout__row">
      <.action phx-click={Corex.Collapsible.set_open("collapsible-api", true)} size="sm">
        Open
      </.action>
      <.action phx-click={Corex.Collapsible.set_open("collapsible-api", false)} size="sm">
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api" >
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
    <div class="layout__row">
      <.action
        phx-click={Corex.Collapsible.set_open("collapsible-api", true)}
        size="sm"
      >
        Open
      </.action>
      <.action
        phx-click={Corex.Collapsible.set_open("collapsible-api", false)}
        size="sm"
      >
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api">
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
    <div class="layout__row">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:collapsible:set-open",
            to: "#collapsible-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        size="sm"
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
        size="sm"
      >
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api-js" >
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
    <div class="layout__row">
      <.action
        phx-click={
          Phoenix.LiveView.JS.dispatch("corex:collapsible:set-open",
            to: "#collapsible-api-js",
            detail: %{open: true},
            bubbles: false
          )
        }
        size="sm"
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
        size="sm"
      >
        Close
      </.action>
    </div>

    <.collapsible id="collapsible-api-js">
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
    <div class="layout__row">
      <.action phx-click="collapsible_api_open" size="sm">Open</.action>
      <.action phx-click="collapsible_api_close" size="sm">Close</.action>
    </div>

    <.collapsible id="collapsible-api-server" >
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
    <div class="layout__row">
      <.action phx-click="collapsible_api_open" size="sm">Open</.action>
      <.action phx-click="collapsible_api_close" size="sm">Close</.action>
    </div>

    <.collapsible id="collapsible-api-server">
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

  def styling_semantic_code do
    ~S"""
    <.collapsible class="collapsible collapsible--md">
      <:trigger>Default width</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible class="collapsible collapsible--md collapsible--accent">
      <:trigger>Accent trigger</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible class="collapsible collapsible--md collapsible--brand">
      <:trigger>Brand trigger</:trigger>
      <:content>Content</:content>
    </.collapsible>
    """
  end

  def styling_semantic_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full max-w-xl">
      <.collapsible id="collapsible-style-default" class="collapsible collapsible--md">
        <:trigger>Default width</:trigger>
        <:content>Content</:content>
      </.collapsible>
      <.collapsible
        id="collapsible-style-accent"
        class="collapsible collapsible--md collapsible--accent"
      >
        <:trigger>Accent trigger</:trigger>
        <:content>Content</:content>
      </.collapsible>
      <.collapsible
        id="collapsible-style-brand"
        class="collapsible collapsible--md collapsible--brand"
      >
        <:trigger>Brand trigger</:trigger>
        <:content>Content</:content>
      </.collapsible>
    </div>
    """
  end

  def styling_size_code do
    ~S"""
    <.collapsible class="collapsible collapsible--sm">
      <:trigger>Small max-width</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible class="collapsible collapsible--lg">
      <:trigger>Large max-width</:trigger>
      <:content>Content</:content>
    </.collapsible>
    """
  end

  def styling_size_example(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 items-start w-full">
      <.collapsible id="collapsible-style-sm" class="collapsible collapsible--sm">
        <:trigger>Small max-width</:trigger>
        <:content>Content</:content>
      </.collapsible>
      <.collapsible id="collapsible-style-lg" class="collapsible collapsible--lg">
        <:trigger>Large max-width</:trigger>
        <:content>Content</:content>
      </.collapsible>
    </div>
    """
  end

  def patterns_async_heex_full do
    ~S"""
    <.async_result :let={panel} assign={@collapsible}>
      <:loading>
        <.collapsible_skeleton  />
      </:loading>

      <.collapsible
        
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

  def style_preview(assigns), do: E2eWeb.Demos.StylePreview.preview(:collapsible, assigns)
  def style_playground(assigns), do: style_preview(assigns)

end
