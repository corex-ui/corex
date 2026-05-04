defmodule E2eWeb.Demos.CollapsibleDemo do
  use E2eWeb, :html

  def anatomy_basic_code do
    ~S"""
    <.collapsible id="collapsible-anatomy" class="collapsible">
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
    <.collapsible id="collapsible-anatomy-custom" class="collapsible">
      <:trigger :let={c}>
        {if c.open, do: "Collapse", else: "Expand"}
      </:trigger>
      <:closed>
        <span class="text-sm text-ink-muted">▼</span>
      </:closed>
      <:opened>
        <span class="text-sm text-ink-muted">▲</span>
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
        <span class="text-sm text-ink-muted">▼</span>
      </:closed>
      <:opened>
        <span class="text-sm text-ink-muted">▲</span>
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
      <.action phx-click={Corex.Collapsible.set_open("collapsible-api", true)} class="button button--sm">
        Open
      </.action>
      <.action phx-click={Corex.Collapsible.set_open("collapsible-api", false)} class="button button--sm">
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
    <div class="layout__row">
      <.action
        phx-click={Corex.Collapsible.set_open("collapsible-api", true)}
        class="button button--sm"
      >
        Open
      </.action>
      <.action
        phx-click={Corex.Collapsible.set_open("collapsible-api", false)}
        class="button button--sm"
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

  def events_server_heex do
    ~S"""
    <.collapsible
      id="collapsible-events-server"
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
    ~S"""
    def handle_event("collapsible_open_changed", %{"id" => id, "open" => open}, socket) do
      log = %{time: "12:00:00", source: "server", value: inspect(%{id: id, open: open})}
      {:noreply, stream_insert(socket, :server_logs, log, at: 0)}
    end
    """
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
    <.collapsible id="collapsible-style-default" class="collapsible collapsible--md">
      <:trigger>Default width</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible id="collapsible-style-accent" class="collapsible collapsible--md collapsible--accent">
      <:trigger>Accent trigger</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible id="collapsible-style-brand" class="collapsible collapsible--md collapsible--brand">
      <:trigger>Brand trigger</:trigger>
      <:content>Content</:content>
    </.collapsible>
    """
  end

  def styling_color_example(assigns) do
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
    <.collapsible id="collapsible-style-sm" class="collapsible collapsible--sm">
      <:trigger>Small max-width</:trigger>
      <:content>Content</:content>
    </.collapsible>
    <.collapsible id="collapsible-style-lg" class="collapsible collapsible--lg">
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
        <.collapsible_skeleton class="collapsible" />
      </:loading>

      <.collapsible
        id="patterns-collapsible-async"
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
      id="patterns-collapsible-controlled"
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
