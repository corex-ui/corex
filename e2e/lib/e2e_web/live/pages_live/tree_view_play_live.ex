defmodule E2eWeb.TreeViewPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      selection_mode: "single",
      dir: "ltr",
      typeahead: true
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:items, E2e.TreeViewDemo.repo_tree())

    {:ok, socket}
  end

  @impl true
  def handle_event("control_changed", %{"checked" => raw, "id" => id}, socket) do
    checked = control_bool(raw)
    {:noreply, update_control(socket, control_id(id), checked)}
  end

  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, control_id(id), value)}
  end

  defp update_control(socket, "selection_mode", value) do
    update(socket, :controls, &%{&1 | selection_mode: value})
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, "typeahead", checked) do
    update(socket, :controls, &%{&1 | typeahead: checked})
  end

  defp update_control(socket, _unknown, _v), do: socket

  defp control_bool(v) when v in [true, "true"], do: true
  defp control_bool(v) when v in [false, "false"], do: false
  defp control_bool(v), do: !!v

  defp control_id("playground-typeahead-" <> _), do: "typeahead"
  defp control_id(id), do: id

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      mode={@mode}
      theme={@theme}
      path={@path}
    >
      <.demo_playground title="Tree view · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm max-w-7xs"
            id="selection_mode"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.selection_mode]}
          >
            <:item value="single">Single</:item>
            <:item value="multiple">Multiple</:item>
          </.toggle_group>

          <.switch
            class="switch"
            id={"playground-typeahead-#{@controls.typeahead}"}
            checked={@controls.typeahead}
            on_checked_change="control_changed"
          >
            <:label>Typeahead</:label>
          </.switch>
        </:controls>
        <:canvas>
          <.tree_view
            id="playground-tree"
            class="tree-view w-full max-w-md"
            expanded_value={E2e.TreeViewDemo.repo_expanded_default()}
            value={E2e.TreeViewDemo.repo_selected_default()}
            selection_mode={@controls.selection_mode}
            dir={@controls.dir}
            typeahead={@controls.typeahead}
            items={@items}
          >
            <:label>Repository</:label>
            <:branch_indicator :let={_row}>
              <.heroicon name="hero-chevron-right" />
            </:branch_indicator>
          </.tree_view>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
