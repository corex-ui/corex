defmodule E2eWeb.CollapsiblePlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  def mount(_params, _session, socket) do
    controls = %{dir: "ltr", orientation: "vertical"}

    {:ok,
     socket
     |> assign(:controls, controls)
     |> assign(:disabled, false)}
  end

  def handle_event("control_changed", %{"checked" => checked, "id" => id}, socket) do
    {:noreply, update_control(socket, id, checked == true or checked == "true")}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  defp update_control(socket, "disabled", v),
    do: assign(socket, :disabled, v)

  defp update_control(socket, "dir", value),
    do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, "orientation", value),
    do: update(socket, :controls, &%{&1 | orientation: value})

  defp update_control(socket, _, _), do: socket

  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground
        id="collapsible-playground"
        title={~t"Collapsible · Playground"}
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm max-w-7xs"
            id="orientation"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.orientation]}
          >
            <:item value="vertical" aria_label={~t"Vertical orientation"}>
              <.heroicon name="hero-arrows-up-down" class="icon icon--lg" />
            </:item>
            <:item value="horizontal" aria_label={~t"Horizontal orientation"}>
              <.heroicon name="hero-arrows-right-left" class="icon icon--lg" />
            </:item>
          </.toggle_group>

          <.switch
            class="switch"
            id="disabled"
            checked={@disabled}
            on_checked_change="control_changed"
          >
            <:label>Disabled</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.collapsible
            id="collapsible-playground-demo"
            class="collapsible"
            disabled={@disabled}
            dir={@controls.dir}
            orientation={@controls.orientation}
          >
            <:trigger>Toggle</:trigger>
            <:closed>
              <.heroicon name="hero-chevron-right" />
            </:closed>
            <:content>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            </:content>
          </.collapsible>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
