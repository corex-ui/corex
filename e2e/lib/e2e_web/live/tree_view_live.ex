defmodule E2eWeb.TreeViewLive do
  use E2eWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:tree_expanded_value, nil)
      |> assign(:tree_selected_value, nil)

    {:ok, socket}
  end

  def handle_event("set_expanded_value", %{"value" => value}, socket) do
    list = if value == "", do: [], else: String.split(value, ",")
    {:noreply, Corex.TreeView.set_expanded_value(socket, "my-tree", list)}
  end

  def handle_event("set_selected_value", %{"value" => value}, socket) do
    list = if value == "", do: [], else: String.split(value, ",")
    {:noreply, Corex.TreeView.set_selected_value(socket, "my-tree", list)}
  end

  def handle_event("get_expanded_value", _params, socket) do
    {:noreply, push_event(socket, "tree_view_expanded_value", %{})}
  end

  def handle_event("get_selected_value", _params, socket) do
    {:noreply, push_event(socket, "tree_view_selected_value", %{})}
  end

  def handle_event("tree_view_expanded_value_response", %{"value" => value}, socket) do
    {:noreply, assign(socket, :tree_expanded_value, value)}
  end

  def handle_event("tree_view_selected_value_response", %{"value" => value}, socket) do
    {:noreply, assign(socket, :tree_selected_value, value)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} mode={@mode} locale={@locale} current_path={@current_path}>
      <div class="layout__row">
        <h1>Tree View</h1>
        <h2>Live View</h2>
      </div>
      <h3>Client Api</h3>
      <div class="layout__row">
        <button
          phx-click={Corex.TreeView.set_expanded_value("my-tree", ["node_modules", "src"])}
          class="button button--sm"
        >
          Expand node_modules & src
        </button>
        <button phx-click={Corex.TreeView.set_expanded_value("my-tree", [])} class="button button--sm">
          Collapse all
        </button>
        <button
          phx-click={Corex.TreeView.set_selected_value("my-tree", ["package.json"])}
          class="button button--sm"
        >
          Select package.json
        </button>
        <button phx-click={Corex.TreeView.set_selected_value("my-tree", [])} class="button button--sm">
          Clear selection
        </button>
      </div>
      <h3>Server Api</h3>
      <div class="layout__row">
        <button
          phx-click="set_expanded_value"
          value={Enum.join(["node_modules", "src"], ",")}
          class="button button--sm"
        >
          Expand node_modules & src
        </button>
        <button phx-click="set_expanded_value" value="" class="button button--sm">
          Collapse all
        </button>
        <button
          phx-click="set_selected_value"
          value="package.json"
          class="button button--sm"
        >
          Select package.json
        </button>
        <button phx-click="set_selected_value" value="" class="button button--sm">
          Clear selection
        </button>
        <button phx-click="get_expanded_value" class="button button--sm">
          Get expanded value
        </button>
        <button phx-click="get_selected_value" class="button button--sm">
          Get selected value
        </button>
      </div>
      <div :if={@tree_expanded_value != nil || @tree_selected_value != nil} class="layout__row">
        <p :if={@tree_expanded_value != nil}>
          Expanded value: <code>{inspect(@tree_expanded_value)}</code>
        </p>
        <p :if={@tree_selected_value != nil}>
          Selected value: <code>{inspect(@tree_selected_value)}</code>
        </p>
      </div>
      <.tree_view id="my-tree" class="tree-view" items={@default_items}>
        <:label>My Documents</:label>
      </.tree_view>
    </Layouts.app>
    """
  end
end
