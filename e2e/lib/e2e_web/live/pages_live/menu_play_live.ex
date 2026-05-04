defmodule E2eWeb.MenuPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      dir: "ltr",
      close_on_select: true,
      loop_focus: false
    }

    {:ok, assign(socket, :controls, controls)}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
    checked = control_bool(raw)
    {:noreply, update_control(socket, id, checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  defp control_bool(v) when v in [true, "true"], do: true
  defp control_bool(v) when v in [false, "false"], do: false
  defp control_bool(v), do: !!v

  defp update_control(socket, "dir", value), do: update(socket, :controls, &%{&1 | dir: value})

  defp update_control(socket, "close_on_select", checked),
    do: update(socket, :controls, &%{&1 | close_on_select: checked})

  defp update_control(socket, "loop_focus", checked),
    do: update(socket, :controls, &%{&1 | loop_focus: checked})

  defp update_control(socket, _unknown, _value), do: socket

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
        id="menu-playground-page"
        title="Menu · Playground"
        heading_class="layout-heading"
      >
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.switch
            class="switch"
            id="close_on_select"
            checked={@controls.close_on_select}
            on_checked_change="control_changed"
          >
            <:label>Close on select</:label>
          </.switch>

          <.switch
            class="switch"
            id="loop_focus"
            checked={@controls.loop_focus}
            on_checked_change="control_changed"
          >
            <:label>Loop focus</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.menu
            id="menu-playground"
            class="menu"
            dir={@controls.dir}
            close_on_select={@controls.close_on_select}
            loop_focus={@controls.loop_focus}
            items={[
              %Corex.Tree.Item{id: "listbox", label: "Listbox"},
              %Corex.Tree.Item{
                id: "corex",
                label: "Corex",
                children: E2eWeb.Demos.MenuDemo.demo_nested_flat_children()
              },
              %Corex.Tree.Item{id: "tabs", label: "Tabs"}
            ]}
          >
            <:trigger>Corex</:trigger>
            <:indicator><.heroicon name="hero-chevron-down" /></:indicator>
            <:nested_indicator><.heroicon name="hero-chevron-right" /></:nested_indicator>
          </.menu>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
