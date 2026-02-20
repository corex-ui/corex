defmodule Corex.TreeView do
  @moduledoc ~S'''
  Phoenix implementation of [Zag.js Tree View](https://zagjs.com/components/react/tree-view).

  ## Examples

  ### Basic

  Pass `items` as `Corex.Tree.new/1`. Component id is the tree root id; names are capitalized from item labels.

  ```heex
  <.tree_view
    id="my-tree"
    class="tree-view"
    items={Corex.Tree.new([
      [label: "Components", id: "components", children: [
        [label: "Accordion", id: "accordion"],
        [label: "Checkbox", id: "checkbox"],
        [label: "Menu", id: "menu"],
        [label: "Tree view", id: "tree-view"]
      ]],
      [label: "Form", id: "form"],
      [label: "Content", id: "content", children: [[label: "Content.Item", id: "content-item"]]],
      [label: "Tree", id: "tree", children: [[label: "Tree.Item", id: "tree-item"]]]
    ])}
  />
  ```

  ### With redirect

  Set `redirect` so selection navigates to the item value (URL). Use item `redirect: false` to disable, `new_tab: true` to open in new tab.

  ```heex
  <.tree_view id="my-tree" class="tree-view" redirect items={Corex.Tree.new([
    [label: "Docs", id: "/docs"],
    [label: "External", id: "https://example.com", new_tab: true]
  ])}>
    <:label>My Documents</:label>
  </.tree_view>
  ```

  ## Styling

  Use data attributes to target elements:

  ```css
  [data-scope="tree-view"][data-part="root"] {}
  [data-scope="tree-view"][data-part="tree"] {}
  [data-scope="tree-view"][data-part="item"] {}
  [data-scope="tree-view"][data-part="branch"] {}
  [data-scope="tree-view"][data-part="branch-control"] {}
  [data-scope="tree-view"][data-part="branch-content"] {}
  [data-scope="tree-view"][data-part="branch-indicator"] {}
  ```

  If you wish to use the default Corex styling, you can use the class `tree-view` on the component.
  This requires to install `Mix.Tasks.Corex.Design` first and import the component css file.

  ```css
  @import "../corex/main.css";
  @import "../corex/tokens/themes/neo/light.css";
  @import "../corex/components/tree-view.css";
  ```

  You can then use modifiers

  ```heex
  <.tree_view class="tree-view tree-view--accent tree-view--lg" items={[]}>
    <:label>Label</:label>
  </.tree_view>
  ```

  Learn more about modifiers and [Corex Design](https://corex-ui.com/components/tree-view#modifiers)
  '''

  @doc type: :component
  use Phoenix.Component

  alias Corex.TreeView.Anatomy.{Props, Root, Label, Branch, Item}
  alias Corex.TreeView.Connect
  import Corex.Helpers, only: [validate_value!: 1]

  @doc """
  Renders a tree view. Pass `items` as `Corex.Tree.new/1`. Component id = tree root id; names capitalized from labels.
  """
  attr(:id, :string,
    required: false,
    doc: "The id of the tree view, useful for API to identify the component"
  )

  attr(:items, :list,
    required: true,
    doc: "The tree items: list of Corex.Tree.Item structs (use Corex.Tree.new/1)"
  )

  attr(:redirect, :boolean,
    default: false,
    doc:
      "When true and not in LiveView, selection navigates to the item value (URL). Use item redirect: false to disable per item, new_tab: true to open in new tab."
  )

  attr(:value, :list,
    default: [],
    doc: "Selected node value(s). Use with controlled."
  )

  attr(:expanded_value, :list,
    default: [],
    doc: "Expanded node value(s). Use with controlled."
  )

  attr(:controlled, :boolean,
    default: false,
    doc: "Whether the tree is controlled (value and expanded_value from server)."
  )

  attr(:selection_mode, :string,
    default: "single",
    values: ["single", "multiple"],
    doc: "Selection mode: single or multiple"
  )

  attr(:dir, :string,
    default: nil,
    values: [nil, "ltr", "rtl"],
    doc: "The direction of the tree."
  )

  attr(:on_selection_change, :string,
    default: nil,
    doc: "The server event name when selection changes"
  )

  attr(:on_expanded_change, :string,
    default: nil,
    doc: "The server event name when expanded state changes"
  )

  attr(:rest, :global)

  slot(:label, doc: "Optional label slot")

  slot(:indicator,
    doc:
      "Content shown in each branch indicator (e.g. chevron icon). Rendered in each branch on the server."
  )

  def tree_view(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> "tree-view-#{System.unique_integer([:positive])}" end)
      |> validate_items()
      |> put_tree()

    ~H"""
    <div
      id={@id}
      phx-hook="TreeView"
      phx-update="ignore"
      {@rest}
      {Connect.props(%Props{
        id: @id,
        tree: @tree,
        value: @value,
        expanded_value: @expanded_value,
        controlled: @controlled,
        selection_mode: @selection_mode,
        redirect: @redirect,
        dir: @dir,
        on_selection_change: @on_selection_change,
        on_expanded_change: @on_expanded_change
      })}
    >
      <div {Connect.root(%Root{id: @id, dir: @dir})}>
        <%= if @label != [] do %>
          <h3 {Connect.label(%Label{id: @id, dir: @dir})}>
            <%= render_slot(@label) %>
          </h3>
        <% end %>
        <div {Connect.tree(%Props{id: @id, dir: @dir})}>
          <%= for {item, i} <- Enum.with_index(@items) do %>
            <.tree_node
              id={@id}
              dir={@dir}
              item={item}
              index_path={[i]}
              expanded_value={@expanded_value}
              value={@value}
              focused_value={if i == 0, do: item.id, else: nil}
            >
              <:indicator><%= render_slot(@indicator) %></:indicator>
            </.tree_node>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  attr(:id, :string, required: true)
  attr(:dir, :string, required: true)
  attr(:item, :any, required: true)
  attr(:index_path, :list, required: true)
  attr(:expanded_value, :list, default: [])
  attr(:value, :list, default: [])
  attr(:focused_value, :string, default: nil)
  slot(:indicator, doc: "Indicator content for branches")

  defp tree_node(assigns) do
    item = assigns.item
    index_path = assigns.index_path
    expanded = item.id in List.wrap(assigns.expanded_value)
    selected = item.id in List.wrap(assigns.value)
    focused = assigns.focused_value != nil and item.id == assigns.focused_value
    name = String.capitalize(item.label)

    branch_assigns = %Branch{
      id: assigns.id,
      value: item.id,
      index_path: index_path,
      name: name,
      dir: assigns.dir,
      expanded: expanded,
      selected: selected,
      focused: focused
    }

    item_assigns = %Item{
      id: assigns.id,
      value: item.id,
      index_path: index_path,
      name: name,
      dir: assigns.dir,
      redirect: item.redirect,
      new_tab: item.new_tab,
      selected: selected,
      focused: focused
    }

    assigns =
      assigns
      |> assign(:branch_assigns, branch_assigns)
      |> assign(:item_assigns, item_assigns)

    if item.children && !Enum.empty?(item.children) do
      ~H"""
      <div {Connect.branch(@branch_assigns)}>
        <div {Connect.branch_trigger(@branch_assigns)}>
          <span {Connect.branch_text(@branch_assigns)}><%= String.capitalize(@item.label) %></span>
          <span {Connect.branch_indicator(@branch_assigns)}>
            <%= if @indicator != [] do %><%= render_slot(@indicator) %><% end %>
          </span>
        </div>
        <div {Connect.branch_content(@branch_assigns)}>
          <div {Connect.branch_indent_guide(@branch_assigns)}></div>
          <%= for {child, j} <- Enum.with_index(@item.children) do %>
            <.tree_node
              id={@id}
              dir={@dir}
              item={child}
              index_path={@index_path ++ [j]}
              expanded_value={@expanded_value}
              value={@value}
              focused_value={@focused_value}
            >
              <:indicator><%= render_slot(@indicator) %></:indicator>
            </.tree_node>
          <% end %>
        </div>
      </div>
      """
    else
      ~H"""
      <div {Connect.item(@item_assigns)}><%= String.capitalize(@item.label) %></div>
      """
    end
  end

  @doc type: :component
  @doc "Renders a tree item (leaf). For custom server-rendered items or testing."
  attr(:item, :map, required: true)
  slot(:inner_block, required: true)

  def tree_item(assigns) do
    ~H"""
    <div {Connect.item(@item)}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc type: :component
  @doc "Renders a tree branch (node with children). For custom server-rendered branches or testing."
  attr(:branch, :map, required: true)
  slot(:inner_block, required: true)
  slot(:trigger, required: true)
  slot(:indicator, required: true)

  def tree_branch(assigns) do
    ~H"""
    <div {Connect.branch(@branch)}>
      <div {Connect.branch_trigger(@branch)}>
        <%= render_slot(@trigger) %>
        <span {Connect.branch_indicator(@branch)}>
          <%= render_slot(@indicator) %>
        </span>
      </div>
      <div {Connect.branch_content(@branch)}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc type: :api
  @doc "Sets the tree expanded value from client-side."
  def set_expanded_value(tree_view_id, value) when is_binary(tree_view_id) do
    Phoenix.LiveView.JS.dispatch("phx:tree-view:set-expanded-value",
      to: "##{tree_view_id}",
      detail: %{value: validate_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc "Sets the tree selected value from client-side."
  def set_selected_value(tree_view_id, value) when is_binary(tree_view_id) do
    Phoenix.LiveView.JS.dispatch("phx:tree-view:set-selected-value",
      to: "##{tree_view_id}",
      detail: %{value: validate_value!(value)},
      bubbles: false
    )
  end

  @doc type: :api
  @doc "Sets the tree expanded value from server-side."
  def set_expanded_value(socket, tree_view_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    Phoenix.LiveView.push_event(socket, "tree_view_set_expanded_value", %{
      tree_view_id: tree_view_id,
      value: validate_value!(value)
    })
  end

  @doc type: :api
  @doc "Sets the tree selected value from server-side."
  def set_selected_value(socket, tree_view_id, value)
      when is_struct(socket, Phoenix.LiveView.Socket) and is_binary(tree_view_id) do
    Phoenix.LiveView.push_event(socket, "tree_view_set_selected_value", %{
      tree_view_id: tree_view_id,
      value: validate_value!(value)
    })
  end

  defp items_to_tree(component_id, items) when is_list(items) do
    %{
      "id" => component_id,
      "name" => "",
      "children" => Enum.map(items, &item_to_node/1)
    }
  end

  defp item_to_node(%Corex.Tree.Item{} = item) do
    node = %{
      "id" => item.id,
      "name" => String.capitalize(item.label),
      "children" => Enum.map(item.children || [], &item_to_node/1)
    }

    node =
      if item.redirect == false do
        Map.put(node, "redirect", false)
      else
        node
      end

    if item.new_tab do
      Map.put(node, "new_tab", true)
    else
      node
    end
  end

  defp validate_items(%{items: nil} = _assigns) do
    raise ArgumentError, """
    tree_view requires :items to be a list of Corex.Tree.Item structs.

    Example:

        items = Corex.Tree.new([
          [label: "Src", id: "src", children: [[label: "index.ts", id: "src/index"]]],
          [label: "Readme", id: "readme"]
        ])
        <.tree_view id="my-tree" items={items} />
    """
  end

  defp validate_items(%{items: items} = assigns) when is_list(items) do
    Enum.each(items, fn item ->
      unless is_struct(item, Corex.Tree.Item) do
        raise ArgumentError, """
        Invalid item in :items. Expected Corex.Tree.Item struct, got: #{inspect(item)}

        Use Corex.Tree.new/1:

            items = Corex.Tree.new([
              [label: "Folder", id: "folder", children: [[label: "File", id: "file"]]],
              [label: "Other", id: "other"]
            ])
            <.tree_view id="my-tree" items={items} />
        """
      end
    end)

    assigns
  end

  defp validate_items(assigns), do: assigns

  defp put_tree(assigns) do
    assign(assigns, :tree, items_to_tree(assigns.id, assigns.items))
  end
end
