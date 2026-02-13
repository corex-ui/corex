defmodule E2eWeb.TreeViewLive do
  use E2eWeb, :live_view

  def mount(%{"locale" => locale} = _params, _session, socket) do
    socket =
      socket
      |> assign(:tree_expanded_value, nil)
      |> assign(:tree_selected_value, nil)
      |> assign(:default_items, default_items(locale))

    {:ok, socket}
  end

  defp default_items(locale) do
    Corex.Tree.new([
      [
        label: "Accordion",
        id: "accordion",
        children: [
          [label: "Controller", id: "/#{locale}/accordion"],
          [label: "Live", id: "/#{locale}/live/accordion"],
          [
            label: "More",
            id: "accordion-more",
            children: [
              [label: "Playground", id: "/#{locale}/playground/accordion"],
              [label: "Controlled", id: "/#{locale}/controlled/accordion"],
              [label: "Async", id: "/#{locale}/async/accordion"]
            ]
          ]
        ]
      ],
      [
        label: "Checkbox",
        id: "checkbox",
        children: [
          [label: "Controller", id: "/#{locale}/checkbox"],
          [label: "Live", id: "/#{locale}/live/checkbox"]
        ]
      ],
      [
        label: "Tree view",
        id: "tree-view",
        children: [
          [label: "Controller", id: "/#{locale}/tree-view"],
          [label: "Live", id: "/#{locale}/live/tree-view"]
        ]
      ]
    ])
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
      <section class="layout__section">
        <div class="layout__row">
          <button
            phx-click={Corex.TreeView.set_expanded_value("my-tree", ["accordion", "checkbox"])}
            class="button button--sm"
          >
            Expand Accordion & Checkbox
          </button>
          <button
            phx-click={Corex.TreeView.set_expanded_value("my-tree", [])}
            class="button button--sm"
          >
            Collapse all
          </button>
          <button
            phx-click={Corex.TreeView.set_selected_value("my-tree", ["/#{@locale}/accordion"])}
            class="button button--sm"
          >
            Select Controller (Accordion)
          </button>
          <button
            phx-click={Corex.TreeView.set_selected_value("my-tree", [])}
            class="button button--sm"
          >
            Clear selection
          </button>
        </div>
      </section>
      <h3>Server Api</h3>
      <section class="layout__section">
        <div class="layout__row">
          <button
            phx-click="set_expanded_value"
            value={Enum.join(["accordion", "checkbox"], ",")}
            class="button button--sm"
          >
            Expand Accordion & Checkbox
          </button>
          <button phx-click="set_expanded_value" value="" class="button button--sm">
            Collapse all
          </button>
          <button
            phx-click="set_selected_value"
            value={"/#{@locale}/accordion"}
            class="button button--sm"
          >
            Select Controller (Accordion)
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
      </section>
      <div :if={@tree_expanded_value != nil || @tree_selected_value != nil} class="layout__row">
        <p :if={@tree_expanded_value != nil}>
          Expanded value: <code>{inspect(@tree_expanded_value)}</code>
        </p>
        <p :if={@tree_selected_value != nil}>
          Selected value: <code>{inspect(@tree_selected_value)}</code>
        </p>
      </div>
      <.tree_view
        id="my-tree"
        class="tree-view"
        redirect
        items={@default_items}
      >
        <:label>Corex Components</:label>
        <:indicator>
          <.icon name="hero-chevron-right" />
        </:indicator>
      </.tree_view>
    </Layouts.app>
    """
  end
end
