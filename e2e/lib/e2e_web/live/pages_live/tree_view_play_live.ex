defmodule E2eWeb.TreeViewPlayLive do
  use E2eWeb, :live_view

  import E2eWeb.DemoPage, only: [demo_playground: 1, playground_dir_toggle: 1]

  @impl true
  def mount(_params, _session, socket) do
    controls = %{
      selection_mode: "single",
      dir: "ltr",
      disabled_items: [],
      disabled_branches: []
    }

    socket =
      socket
      |> assign(:controls, controls)
      |> assign(:disabled_item_select_items, disabled_item_select_items())
      |> assign(:disabled_branch_select_items, disabled_branch_select_items())
      |> assign(:items, tree_items(controls))

    {:ok, socket}
  end

  @impl true
  def handle_event("control_changed", %{"value" => [value], "id" => id}, socket) do
    {:noreply, update_control(socket, id, value)}
  end

  @impl true
  def handle_event("disabled_items_changed", %{"value" => value}, socket) when is_list(value) do
    {:noreply, sync_items(socket, disabled_items: value)}
  end

  @impl true
  def handle_event("disabled_items_changed", _params, socket) do
    {:noreply, sync_items(socket, disabled_items: [])}
  end

  @impl true
  def handle_event("disabled_branches_changed", %{"value" => value}, socket)
      when is_list(value) do
    {:noreply, sync_items(socket, disabled_branches: value)}
  end

  @impl true
  def handle_event("disabled_branches_changed", _params, socket) do
    {:noreply, sync_items(socket, disabled_branches: [])}
  end

  defp update_control(socket, "selection_mode", value) do
    update(socket, :controls, &%{&1 | selection_mode: value})
  end

  defp update_control(socket, "dir", value) do
    update(socket, :controls, &%{&1 | dir: value})
  end

  defp update_control(socket, _unknown, _v), do: socket

  defp sync_items(socket, overrides) do
    controls = Map.merge(socket.assigns.controls, Map.new(overrides))

    socket
    |> assign(:controls, controls)
    |> assign(:items, tree_items(controls))
  end

  defp tree_items(%{disabled_items: disabled_items, disabled_branches: disabled_branches}) do
    E2e.TreeViewDemo.repo_tree()
    |> apply_disabled(disabled_items, disabled_branches)
  end

  defp apply_disabled(items, disabled_items, disabled_branches) when is_list(items) do
    Enum.map(items, &apply_disabled_item(&1, disabled_items, disabled_branches))
  end

  defp apply_disabled_item(
         %Corex.Tree.Item{children: children} = item,
         disabled_items,
         disabled_branches
       )
       when is_list(children) and children != [] do
    disabled = item.value in disabled_branches

    children =
      Enum.map(children, &apply_disabled_item(&1, disabled_items, disabled_branches))

    struct!(item, %{disabled: disabled, children: children})
  end

  defp apply_disabled_item(%Corex.Tree.Item{} = item, disabled_items, _disabled_branches) do
    struct!(item, %{disabled: item.value in disabled_items})
  end

  defp disabled_item_select_items do
    [
      %{label: "tree_view.ex", value: "lib-tree-view-ex"},
      %{label: "tree_view_demo.ex", value: "lib-tree-view-demo-ex"},
      %{label: "tree_view_test.exs", value: "test-tree-view-test-exs"},
      %{label: "tree-view.ts", value: "assets-tree-view-ts"},
      %{label: "mix.exs", value: "mix-exs"}
    ]
  end

  defp disabled_branch_select_items do
    [
      %{label: "lib", value: "lib"},
      %{label: "test", value: "test"},
      %{label: "assets", value: "assets"}
    ]
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
      <.demo_playground path={@path} title="Tree view · Playground" heading_class="layout-heading">
        <:controls>
          <.playground_dir_toggle
            id="dir"
            on_value_change="control_changed"
            value={[@controls.dir]}
          />

          <.toggle_group
            class="toggle-group toggle-group--sm max-w-3xs"
            id="selection_mode"
            on_value_change="control_changed"
            multiple={false}
            deselectable={false}
            value={[@controls.selection_mode]}
          >
            <:item value="single">Single</:item>
            <:item value="multiple">Multiple</:item>
          </.toggle_group>

          <.select
            id="playground-disabled-items"
            class="select select--sm w-4xs"
            multiple
            deselectable={true}
            close_on_select={false}
            value={@controls.disabled_items}
            items={@disabled_item_select_items}
            on_value_change="disabled_items_changed"
            translation={%Corex.Select.Translation{placeholder: "Select items"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Disabled items</:label>
          </.select>

          <.select
            id="playground-disabled-branches"
            class="select select--sm w-4xs"
            multiple
            deselectable={true}
            close_on_select={false}
            value={@controls.disabled_branches}
            items={@disabled_branch_select_items}
            on_value_change="disabled_branches_changed"
            translation={%Corex.Select.Translation{placeholder: "Select branches"}}
            positioning={%Corex.Positioning{same_width: true}}
          >
            <:trigger><.heroicon name="hero-chevron-down" /></:trigger>
            <:label>Disabled branches</:label>
          </.select>
        </:controls>
        <:canvas>
          <.tree_view
            id="playground-tree"
            class="tree-view w-full max-w-md"
            expanded_value={E2e.TreeViewDemo.repo_expanded_default()}
            value={E2e.TreeViewDemo.repo_selected_default()}
            selection_mode={@controls.selection_mode}
            dir={@controls.dir}
            items={@items}
          >
            <:label>Repository</:label>
            <:branch_indicator>
              <.heroicon name="hero-chevron-right" class="icon" />
            </:branch_indicator>
            <:item_indicator>
              <.heroicon name="hero-check" class="icon" />
            </:item_indicator>
            <:branch :let={branch}>
              <.heroicon name="hero-folder" class="icon" />{branch.label}
            </:branch>
            <:item :let={item}>
              <.heroicon name="hero-document" class="icon" />{item.label}
            </:item>
          </.tree_view>
        </:canvas>
      </.demo_playground>
    </Layouts.app>
    """
  end
end
