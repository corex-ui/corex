defmodule E2eWeb.TooltipPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:show_arrow, true)
      |> assign(:placement, "bottom")
      |> assign(:dir, "ltr")

    {:ok, socket}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => "dir"}, socket)
      when is_binary(value) do
    {:noreply, assign(socket, :dir, value)}
  end

  @impl true
  def handle_event("control_changed", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("show_arrow_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :show_arrow, checked == true or checked == "true")}
  end

  @impl true
  def handle_event("placement_changed", %{"placement" => placement}, socket) do
    {:noreply, assign(socket, :placement, placement)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground
        id="tooltip-playground-page"
        title="Tooltip · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle id="dir" on_value_change="control_changed" value={[@dir]} />
          <.switch
            class="switch"
            id="playground-tooltip-arrow"
            checked={@show_arrow}
            on_checked_change="show_arrow_changed"
          >
            <:label>Show arrow</:label>
          </.switch>
          <label class="native-input">
            <span class="native-input__label">Placement</span>
            <select
              class="native-input__control"
              name="placement"
              phx-change="placement_changed"
              value={@placement}
            >
              <option value="bottom">bottom</option>
              <option value="top">top</option>
              <option value="left">left</option>
              <option value="right">right</option>
              <option value="top-start">top-start</option>
              <option value="bottom-end">bottom-end</option>
            </select>
          </label>
        </:controls>
        <:canvas>
          <.tooltip
            id="tooltip-play-canvas"
            class="tooltip"
            placement={@placement}
            show_arrow={@show_arrow}
            dir={@dir}
          >
            <:trigger>Hover me</:trigger>
            <:content>Tooltip content</:content>
          </.tooltip>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
