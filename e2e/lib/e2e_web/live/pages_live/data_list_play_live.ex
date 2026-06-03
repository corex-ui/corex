defmodule E2eWeb.DataListPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  alias E2eWeb.Demos.DataListDemo, as: Demo

  @impl true
  def mount(_params, _session, socket) do
    controls = %{dir: "ltr", orientation: "vertical"}

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:items, Demo.playground_items())}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, control_id(id), value)}
  end

  defp update_control(socket, "orientation", value) do
    update(socket, :controls, &%{&1 | orientation: value})
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, _id, _value), do: socket

  defp control_id("orientation"), do: "orientation"
  defp control_id("dir"), do: "dir"
  defp control_id(_), do: nil

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
        path={@path}
        id="data-list-playground"
        title="Data List · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />
          <.toggle_group
            class="toggle-group toggle-group--sm toggle--max-w-7xs"
            id="orientation"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.orientation]}
          >
            <:item value="vertical" aria_label="Vertical orientation">
              <.heroicon name="hero-arrows-up-down" />
            </:item>
            <:item value="horizontal" aria_label="Horizontal orientation">
              <.heroicon name="hero-arrows-right-left" />
            </:item>
          </.toggle_group>
        </:controls>
        <:canvas>
          <.data_list
            dir={@controls.dir}
            orientation={@controls.orientation}
            items={@items}
          />
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
