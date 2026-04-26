defmodule E2eWeb.Demos.TooltipDemo do
  use E2eWeb, :html

  def anatomy_default_open_code do
    ~S"""
    <.tooltip id="tooltip-default-open" class="tooltip" open>
      <:trigger>Hover or focus (starts open)</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_default_open_example(assigns) do
    ~H"""
    <.tooltip id="tooltip-default-open" class="tooltip" open>
      <:trigger>Hover or focus (starts open)</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def anatomy_placement_code do
    ~S"""
    <div class="layout__row gap-2">
      <.tooltip class="tooltip" placement="bottom">
        <:trigger>Bottom</:trigger>
        <:content>Tooltip below</:content>
      </.tooltip>
      <.tooltip class="tooltip" placement="top">
        <:trigger>Top</:trigger>
        <:content>Tooltip above</:content>
      </.tooltip>
      <.tooltip class="tooltip" placement="left">
        <:trigger>Left</:trigger>
        <:content>Tooltip on the left</:content>
      </.tooltip>
      <.tooltip class="tooltip" placement="right">
        <:trigger>Right</:trigger>
        <:content>Tooltip on the right</:content>
      </.tooltip>
    </div>
    """
  end

  def anatomy_placement_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.tooltip class="tooltip" placement="bottom">
        <:trigger>Bottom</:trigger>
        <:content>Tooltip below</:content>
      </.tooltip>
      <.tooltip class="tooltip" placement="top">
        <:trigger>Top</:trigger>
        <:content>Tooltip above</:content>
      </.tooltip>
      <.tooltip class="tooltip" placement="left">
        <:trigger>Left</:trigger>
        <:content>Tooltip on the left</:content>
      </.tooltip>
      <.tooltip class="tooltip" placement="right">
        <:trigger>Right</:trigger>
        <:content>Tooltip on the right</:content>
      </.tooltip>
    </div>
    """
  end

  def anatomy_variants_code do
    ~S"""
    <div class="layout__row gap-2">
      <.tooltip class="tooltip tooltip--sm" show_arrow>
        <:trigger>Small</:trigger>
        <:content>Small tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip" show_arrow>
        <:trigger>Default</:trigger>
        <:content>Default tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--lg" show_arrow>
        <:trigger>Large</:trigger>
        <:content>Large tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--accent" show_arrow>
        <:trigger>Accent</:trigger>
        <:content>Accent tooltip</:content>
      </.tooltip>
    </div>
    """
  end

  def anatomy_variants_example(assigns) do
    ~H"""
    <div class="layout__row gap-2">
      <.tooltip class="tooltip tooltip--sm" show_arrow>
        <:trigger>Small</:trigger>
        <:content>Small tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip" show_arrow>
        <:trigger>Default</:trigger>
        <:content>Default tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--lg" show_arrow>
        <:trigger>Large</:trigger>
        <:content>Large tooltip</:content>
      </.tooltip>
      <.tooltip class="tooltip tooltip--accent" show_arrow>
        <:trigger>Accent</:trigger>
        <:content>Accent tooltip</:content>
      </.tooltip>
    </div>
    """
  end

  def api_set_open_client_binding_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", true)} class="button button--sm">Open</.action>
      <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", false)} class="button button--sm">Close</.action>
    </div>
    <.tooltip id="tooltip-api-cb" class="tooltip">
      <:trigger>Hover or focus</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def api_set_open_client_binding_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", true)} class="button button--sm">
          Open
        </.action>
        <.action phx-click={Corex.Tooltip.set_open("tooltip-api-cb", false)} class="button button--sm">
          Close
        </.action>
      </div>
      <.tooltip id="tooltip-api-cb" class="tooltip">
        <:trigger>Hover or focus</:trigger>
        <:content>Tooltip content</:content>
      </.tooltip>
    </div>
    """
  end

  def api_set_open_client_js_heex do
    ~S"""
    <button
      type="button"
      class="button button--sm"
      onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: true } }))"
    >
      Open (client JS)
    </button>
    <.tooltip id="tooltip-api-cjs" class="tooltip">
      <:trigger>Target</:trigger>
      <:content>Tooltip</:content>
    </.tooltip>
    """
  end

  def api_set_open_client_js_js do
    ~S"""
    const el = document.getElementById("tooltip-api-cjs");
    el?.dispatchEvent(
      new CustomEvent("corex:tooltip:set-open", { bubbles: false, detail: { open: true } })
    );
    """
  end

  def api_set_open_client_js_ts do
    api_set_open_client_js_js()
  end

  def api_set_open_client_js_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <button
          type="button"
          class="button button--sm"
          onclick="document.getElementById('tooltip-api-cjs')?.dispatchEvent(new CustomEvent('corex:tooltip:set-open', {bubbles: false, detail: { open: true } }))"
        >
          Open (client JS)
        </button>
      </div>
      <.tooltip id="tooltip-api-cjs" class="tooltip">
        <:trigger>Target</:trigger>
        <:content>Tooltip</:content>
      </.tooltip>
    </div>
    """
  end

  def api_set_open_server_heex do
    ~S"""
    <div class="layout__row">
      <.action phx-click="tooltip_api_open" class="button button--sm">Open</.action>
      <.action phx-click="tooltip_api_close" class="button button--sm">Close</.action>
    </div>
    <.tooltip id="tooltip-api-srv" class="tooltip">
      <:trigger>Hover or focus</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def api_set_open_server_elixir do
    ~S"""
    def handle_event("tooltip_api_open", _params, socket) do
      {:noreply, Corex.Tooltip.set_open(socket, "tooltip-api-srv", true)}
    end

    def handle_event("tooltip_api_close", _params, socket) do
      {:noreply, Corex.Tooltip.set_open(socket, "tooltip-api-srv", false)}
    end
    """
  end

  def api_set_open_server_example(assigns) do
    _ = assigns

    ~H"""
    <div class="w-full max-w-4xl flex flex-col gap-4">
      <div class="layout__row">
        <.action phx-click="tooltip_api_open" class="button button--sm">Open</.action>
        <.action phx-click="tooltip_api_close" class="button button--sm">Close</.action>
      </div>
      <.tooltip id="tooltip-api-srv" class="tooltip">
        <:trigger>Hover or focus</:trigger>
        <:content>Tooltip content</:content>
      </.tooltip>
    </div>
    """
  end

  def api_codes do
    %{
      set_open_client_binding: api_set_open_client_binding_heex(),
      set_open_client_js_heex: api_set_open_client_js_heex(),
      set_open_client_js: api_set_open_client_js_js(),
      set_open_client_ts: api_set_open_client_js_ts(),
      set_open_server_heex: api_set_open_server_heex(),
      set_open_server_elixir: api_set_open_server_elixir()
    }
  end

  def api_client_binding_code, do: api_set_open_client_binding_heex()

  def api_client_binding_example(assigns), do: api_set_open_client_binding_example(assigns)

  def patterns_controlled_heex do
    ~S"""
    <.tooltip
      id="tooltip-patterns-controlled"
      class="tooltip"
      controlled
      open={@open}
      on_open_change="tooltip_pattern_open"
    >
      <:trigger>Controlled</:trigger>
      <:content>Synced with assign</:content>
    </.tooltip>
    """
  end

  def patterns_controlled_elixir do
    ~S"""
    def mount(_params, _session, socket) do
      {:ok, assign(socket, :open, false)}
    end

    def handle_event("tooltip_pattern_open", %{"open" => open, "id" => _}, socket) do
      o = open == true or open == "true"
      {:noreply, assign(socket, :open, o)}
    end
    """
  end

  attr :open, :boolean, default: false

  def patterns_controlled_example(assigns) do
    ~H"""
    <.tooltip
      id="tooltip-patterns-controlled"
      class="tooltip"
      controlled
      open={@open}
      on_open_change="tooltip_pattern_open"
    >
      <:trigger>Controlled</:trigger>
      <:content>Synced with assign</:content>
    </.tooltip>
    """
  end

  def events_server_heex do
    ~S"""
    <.tooltip
      id="tooltip-events"
      class="tooltip"
      on_open_change="tooltip_open_changed"
      on_open_change_client="tooltip-open-changed"
    >
      <:trigger>Hover me</:trigger>
      <:content>Tooltip content</:content>
    </.tooltip>
    """
  end

  def events_server_elixir do
    ~S"""
    def handle_event("tooltip_open_changed", %{"open" => open, "id" => id}, socket) do
      _ = {open, id}
      {:noreply, socket}
    end
    """
  end

  def events_client_listener_js do
    ~S"""
    const el = document.getElementById("tooltip-events");
    el?.addEventListener("tooltip-open-changed", (event) => {
      console.log(event.detail);
    });
    """
  end

  def styling_size_color_code do
    anatomy_variants_code()
  end

  def styling_size_color_example(assigns) do
    anatomy_variants_example(assigns)
  end
end
