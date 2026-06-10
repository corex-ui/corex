defmodule E2eWeb.ToggleGroupPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      multiple: true,
      deselectable: false,
      dir: "ltr",
      orientation: "horizontal"
    }

    {:ok, assign(socket, :controls, controls)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
    checked = raw == true or raw == "true"
    id = to_string(id)
    socket = update_control(socket, id, checked)
    {:noreply, socket}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, to_string(id), value)}
  end

  def handle_event("control_changed", _params, socket), do: {:noreply, socket}

  defp update_control(socket, "orientation", value),
    do: update(socket, :controls, &%{&1 | orientation: value})

  defp update_control(socket, "dir", value),
    do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, "multiple", true),
    do: update(socket, :controls, &Map.put(&1, :multiple, true))

  defp update_control(socket, "multiple", false),
    do: update(socket, :controls, &Map.put(&1, :multiple, false))

  defp update_control(socket, "deselectable", v),
    do: update(socket, :controls, &Map.put(&1, :deselectable, v))

  defp update_control(socket, _, _), do: socket

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
        id="toggle-group-playground-page"
        title="Toggle group · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--size-sm toggle--max-w-7xs"
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

          <.switch
            size="sm"
            id="multiple"
            checked={@controls.multiple}
            on_checked_change="control_changed"
          >
            <:label>Multiple</:label>
          </.switch>

          <.switch
            size="sm"
            id="deselectable"
            checked={@controls.deselectable}
            on_checked_change="control_changed"
          >
            <:label>Deselectable</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.toggle_group
            id="toggle-group-play"
            multiple={@controls.multiple}
            deselectable={@controls.deselectable}
            dir={@controls.dir}
            orientation={@controls.orientation}
          >
            <:item value="lorem">Lorem</:item>
            <:item value="duis">Duis</:item>
            <:item value="donec">Donec</:item>
          </.toggle_group>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
