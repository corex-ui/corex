defmodule E2eWeb.TabsPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:vertical, false)
     |> assign(:dir, "ltr")}
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
  def handle_event("vertical_changed", %{"checked" => checked, "id" => _}, socket) do
    {:noreply, assign(socket, :vertical, checked == true or checked == "true")}
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
      <.demo_playground title="Tabs · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle id="dir" on_value_change="control_changed" value={[@dir]} />
          <.switch
            class="switch"
            id="playground-tabs-vertical"
            checked={@vertical}
            on_checked_change="vertical_changed"
          >
            <:label>Vertical</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.tabs
            id="tabs-playground"
            class="tabs w-full"
            value="lorem"
            dir={@dir}
            orientation={if(@vertical, do: "vertical", else: "horizontal")}
            items={E2eWeb.Demos.TabsDemo.basic_items()}
          />
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
