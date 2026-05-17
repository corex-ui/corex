defmodule Corex.TreeViewTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Json
  alias Corex.TreeView
  alias Corex.TreeView.Connect

  @zag_root %{"value" => "test-tree", "name" => "", "children" => []}

  describe "tree_view/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_tree_view/1, [])
      assert html =~ ~r/data-scope="tree-view"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r//
      assert html =~ ~r/phx-mounted=/
      assert html =~ ~r/Item/
    end

    test "raises on nil items" do
      assert_raise ArgumentError, ~r/tree_view requires :items to be a list/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.TreeView.tree_view id="t1" items={nil} />
            """
          end,
          %{}
        )
      end
    end

    test "raises on invalid items" do
      assert_raise ArgumentError, ~r/Invalid item in :items/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.TreeView.tree_view id="t2" items={["invalid"]} />
            """
          end,
          %{}
        )
      end
    end

    test "merges :label slot class onto data-part label host" do
      items = Corex.Tree.new([%{label: "A", value: "a"}])

      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.TreeView.tree_view id="t-label-class" items={@items}>
              <:label class="sr-only">Docs</:label>
            </Corex.TreeView.tree_view>
            """
          end,
          %{items: items}
        )

      assert html =~ ~s(data-part="label")
      assert html =~ ~s(class="sr-only")
    end

    test "renders expanded and selected values" do
      items =
        Corex.Tree.new([
          %{label: "P1", value: "p1", children: [%{label: "C1", value: "c1"}]}
        ])

      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.TreeView.tree_view id="t3" items={@items} expanded_value={["p1"]} value={["c1"]} />
            """
          end,
          %{items: items}
        )

      assert html =~ ~s(data-state="open")
      assert html =~ ~s(data-selected)
    end
  end

  describe "tree_view_markup_item/1 and tree_view_markup_branch/1" do
    test "renders tree_view_markup_item" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.TreeView.tree_view_markup_item item={%{id: "i1", value: "v1", index_path: [0], dir: "ltr", redirect: true, new_tab: false, selected: false, focused: false, name: "I1", disabled: false}}>Leaf</Corex.TreeView.tree_view_markup_item>
            """
          end,
          %{}
        )

      assert html =~ "Leaf"
      assert html =~ "data-part=\"item\""
      assert html =~ "data-part=\"item-text\""
    end

    test "renders tree_view_markup_branch" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.TreeView.tree_view_markup_branch row={%{id: "b1", value: "v1", index_path: [0], dir: "ltr", expanded: false, disabled: false, selected: false, focused: false, name: "B1"}}>
              <:branch>Trigger</:branch>
              <:branch_indicator>Icon</:branch_indicator>
              Content
            </Corex.TreeView.tree_view_markup_branch>
            """
          end,
          %{}
        )

      assert html =~ "Trigger"
      assert html =~ "Icon"
      assert html =~ "Content"
      assert html =~ "data-part=\"branch\""
    end
  end

  describe "set_expanded_value/2" do
    test "returns JS command with list" do
      js = TreeView.set_expanded_value("my-tree", ["node-1"])
      assert %Phoenix.LiveView.JS{} = js
    end

    test "accepts empty list" do
      js = TreeView.set_expanded_value("my-tree", [])
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_selected_value/2" do
    test "returns JS command" do
      js = TreeView.set_selected_value("my-tree", ["node-1"])
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_expanded_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = TreeView.set_expanded_value(socket, "my-tree", ["node-1"])
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "set_selected_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = TreeView.set_selected_value(socket, "my-tree", ["node-1"])
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "value/1" do
    test "returns JS command" do
      js = TreeView.value("my-tree")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "value/2 (client)" do
    test "returns JS command with respond_to opts" do
      js = TreeView.value("my-tree", respond_to: :client)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "value/2 (server)" do
    test "pushes tree_view_value event with id" do
      socket = %Phoenix.LiveView.Socket{}
      result = TreeView.value(socket, "my-tree")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "value/3 (server)" do
    test "pushes tree_view_value event with respond_to opts" do
      socket = %Phoenix.LiveView.Socket{}
      result = TreeView.value(socket, "my-tree", respond_to: :both)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "expanded_value/1" do
    test "returns JS command" do
      js = TreeView.expanded_value("my-tree")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "expanded_value/2 (client)" do
    test "returns JS command with respond_to opts" do
      js = TreeView.expanded_value("my-tree", respond_to: :client)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "expanded_value/2 (server)" do
    test "pushes tree_view_expanded_value event with id" do
      socket = %Phoenix.LiveView.Socket{}
      result = TreeView.expanded_value(socket, "my-tree")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "expanded_value/3 (server)" do
    test "pushes tree_view_expanded_value event with respond_to opts" do
      socket = %Phoenix.LiveView.Socket{}
      result = TreeView.expanded_value(socket, "my-tree", respond_to: :both)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-tree", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "tree:test-tree:root"
      assert result["data-scope"] == "tree-view"
      assert result["data-part"] == "root"
    end

    test "computes root with rtl direction" do
      assigns = %{id: "test-tree", dir: "rtl"}
      result = Connect.root(assigns)
      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-tree", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["id"] == "tree:test-tree:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.tree/1" do
    test "returns tree attributes" do
      assigns = %{id: "test-tree", dir: "ltr"}
      result = Connect.tree(assigns)
      assert result["id"] == "tree:test-tree:tree"
      assert result["data-part"] == "tree"
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [0],
        disabled: false,
        redirect: true,
        new_tab: false,
        dir: "ltr"
      }

      result = Connect.item(assigns)
      assert result["id"] == "tree:test-tree:node:node-1"
      assert result["data-value"] == "node-1"
      assert result["style"] == "--depth: 1"
    end

    test "adds data-name when name present" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        disabled: false,
        redirect: true,
        new_tab: false,
        dir: "ltr",
        name: "my-link"
      }

      result = Connect.item(assigns)
      assert result["data-name"] == "my-link"
    end

    test "adds data-redirect when redirect false" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        disabled: false,
        redirect: false,
        new_tab: false,
        dir: "ltr"
      }

      result = Connect.item(assigns)
      assert result["data-redirect"] == "false"
    end

    test "stringifies atom redirect modes" do
      for mode <- [:href, :patch, :navigate] do
        assigns = %{
          id: "test-tree",
          value: "node-1",
          index_path: [],
          disabled: false,
          redirect: mode,
          new_tab: false,
          dir: "ltr"
        }

        result = Connect.item(assigns)
        assert result["data-redirect"] == Atom.to_string(mode)
      end
    end

    test "adds data-new-tab when new_tab true" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        disabled: false,
        redirect: true,
        new_tab: true,
        dir: "ltr"
      }

      result = Connect.item(assigns)
      assert Map.has_key?(result, "data-new-tab")
    end

    test "adds data-selected when selected true" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        disabled: false,
        redirect: true,
        new_tab: false,
        dir: "ltr",
        selected: true
      }

      result = Connect.item(assigns)
      assert Map.has_key?(result, "data-selected")
    end

    test "adds data-focus when focused true" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        disabled: false,
        redirect: true,
        new_tab: false,
        dir: "ltr",
        focused: true
      }

      result = Connect.item(assigns)
      assert Map.has_key?(result, "data-focus")
    end

    test "uses depth 0 when index_path is not list" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: nil,
        disabled: false,
        redirect: true,
        new_tab: false,
        dir: "ltr"
      }

      result = Connect.item(assigns)
      assert result["style"] == "--depth: 0"
    end
  end

  describe "Connect.branch/1" do
    test "returns branch attributes when expanded" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [0],
        expanded: true,
        disabled: false,
        dir: "ltr"
      }

      result = Connect.branch(assigns)
      assert result["data-state"] == "open"
      assert result["data-part"] == "branch"
    end

    test "returns branch attributes when collapsed" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        disabled: false,
        dir: "ltr"
      }

      result = Connect.branch(assigns)
      assert result["data-state"] == "closed"
    end

    test "adds data-name when name present" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        disabled: false,
        dir: "ltr",
        name: "branch-link"
      }

      result = Connect.branch(assigns)
      assert result["data-name"] == "branch-link"
    end

    test "adds data-selected when selected true" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        disabled: false,
        dir: "ltr",
        selected: true
      }

      result = Connect.branch(assigns)
      assert Map.has_key?(result, "data-selected")
    end

    test "adds data-focus when focused true" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        disabled: false,
        dir: "ltr",
        focused: true
      }

      result = Connect.branch(assigns)
      assert Map.has_key?(result, "data-focus")
    end
  end

  describe "Connect.branch_trigger/1" do
    test "returns branch trigger attributes" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [0],
        expanded: true,
        disabled: false,
        dir: "ltr"
      }

      result = Connect.branch_trigger(assigns)
      assert result["data-part"] == "branch-control"
      assert result["data-state"] == "open"
    end

    test "adds data-selected when selected true" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        disabled: false,
        dir: "ltr",
        selected: true
      }

      result = Connect.branch_trigger(assigns)
      assert Map.has_key?(result, "data-selected")
    end

    test "adds data-focus when focused true" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        disabled: false,
        dir: "ltr",
        focused: true
      }

      result = Connect.branch_trigger(assigns)
      assert Map.has_key?(result, "data-focus")
    end
  end

  describe "Connect.branch_content/1" do
    test "returns branch content when expanded" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: true,
        dir: "ltr"
      }

      result = Connect.branch_content(assigns)
      refute Map.has_key?(result, "hidden")
    end

    test "adds hidden when collapsed only for instant animation" do
      instant = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        dir: "ltr",
        animation: "instant"
      }

      assert Connect.branch_content(instant)["hidden"] == ""

      for animation <- ["js", "custom"] do
        assigns = %{instant | animation: animation}
        result = Connect.branch_content(assigns)
        refute Map.has_key?(result, "hidden")
      end
    end

    test "adds hidden when collapsed with default animation" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        dir: "ltr"
      }

      result = Connect.branch_content(assigns)
      assert Map.has_key?(result, "hidden")
    end
  end

  describe "Connect.branch_indicator/1" do
    test "returns branch indicator attributes" do
      assigns = %{
        id: "test-tree",
        value: "node-1",
        index_path: [],
        expanded: false,
        disabled: false,
        dir: "ltr"
      }

      result = Connect.branch_indicator(assigns)
      assert result["data-part"] == "branch-indicator"
      assert result["data-state"] == "closed"
    end
  end

  describe "Connect.branch_text/1" do
    test "returns branch text attributes" do
      assigns = %{id: "test-tree", value: "node-1", index_path: [], dir: "ltr"}
      result = Connect.branch_text(assigns)
      assert result["data-part"] == "branch-text"
    end
  end

  describe "Connect.item_text/1" do
    test "returns item text attributes for leaves" do
      assigns = %{id: "test-tree", value: "leaf-1", index_path: [0, 1], dir: "ltr"}
      result = Connect.item_text(assigns)
      assert result["data-part"] == "item-text"
      assert result["data-value"] == "leaf-1"
    end
  end

  describe "Connect.item_indicator/1" do
    test "returns item indicator attributes" do
      assigns = %{
        id: "test-tree",
        value: "leaf-1",
        index_path: [0],
        dir: "ltr",
        disabled: false,
        selected: false,
        focused: false
      }

      result = Connect.item_indicator(assigns)
      assert result["data-part"] == "item-indicator"
    end
  end

  describe "Connect.branch_indent_guide/1" do
    test "returns branch indent guide attributes" do
      assigns = %{id: "test-tree", value: "node-1", index_path: [0], dir: "ltr"}
      result = Connect.branch_indent_guide(assigns)
      assert result["data-part"] == "branch-indent-guide"
    end
  end

  describe "Connect.props/1" do
    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-tree",
        tree: @zag_root,
        controlled: false,
        expanded_value: ["node-1"],
        value: ["node-2"],
        selection_mode: "single",
        dir: "ltr",
        on_selection_change: nil,
        on_expanded_change: nil,
        redirect: true
      }

      result = Connect.props(assigns)
      assert result["data-tree"] == Json.encode!(@zag_root)
      assert result["data-default-expanded-value"] == "node-1"
      assert result["data-default-selected-value"] == "node-2"
      assert result["data-expanded-value"] == nil
      assert result["data-selected-value"] == nil
      assert result["data-typeahead"] == "true"
    end

    test "returns props when controlled" do
      assigns = %{
        id: "test-tree",
        tree: @zag_root,
        controlled: true,
        expanded_value: ["node-1"],
        value: ["node-2"],
        selection_mode: "single",
        dir: "ltr",
        on_selection_change: nil,
        on_expanded_change: nil,
        redirect: true
      }

      result = Connect.props(assigns)
      assert result["data-tree"] == Json.encode!(@zag_root)
      assert result["data-default-expanded-value"] == nil
      assert result["data-default-selected-value"] == nil
      assert result["data-expanded-value"] == "node-1"
      assert result["data-selected-value"] == "node-2"
      assert result["data-typeahead"] == "true"
    end

    test "returns props with redirect false" do
      assigns = %{
        id: "test-tree",
        tree: @zag_root,
        controlled: false,
        expanded_value: [],
        value: [],
        selection_mode: "single",
        dir: "ltr",
        on_selection_change: nil,
        on_expanded_change: nil,
        redirect: false
      }

      result = Connect.props(assigns)
      assert result["data-tree"] == Json.encode!(@zag_root)
      assert result["data-redirect"] == nil
      assert result["data-typeahead"] == "true"
    end

    test "returns data-typeahead false when disabled" do
      assigns = %{
        id: "test-tree",
        tree: @zag_root,
        controlled: false,
        expanded_value: [],
        value: [],
        selection_mode: "single",
        dir: "ltr",
        typeahead: false,
        on_selection_change: nil,
        on_expanded_change: nil,
        redirect: false
      }

      result = Connect.props(assigns)
      assert result["data-typeahead"] == "false"
    end

    test "does not merge animation_options when animation is not js" do
      assigns = %{
        id: "test-tree",
        tree: @zag_root,
        animation: "custom",
        animation_options: %Corex.Animation.Height{duration: 0.9},
        controlled: false,
        expanded_value: [],
        value: [],
        selection_mode: "single",
        dir: "ltr",
        on_selection_change: nil,
        on_expanded_change: nil,
        redirect: false
      }

      result = Connect.props(assigns)
      assert result["data-animation"] == "custom"
      refute Map.has_key?(result, "data-anim-height-duration")
    end
  end

  describe "tree_view/1 with options" do
    test "renders with branch" do
      html = render_component(&CorexTest.ComponentHelpers.render_tree_view_with_branch/1, [])
      assert html =~ ~r/data-scope="tree-view"/
      assert html =~ ~r/Parent/
      assert html =~ ~r/Child/
    end

    test "renders with controlled" do
      html = render_component(&CorexTest.ComponentHelpers.render_tree_view_controlled/1, [])
      assert html =~ ~r/data-scope="tree-view"/
      assert html =~ ~r/data-controlled/
    end

    test "tree_view_skeleton renders loading markup" do
      html = render_component(&TreeView.tree_view_skeleton/1, count: 2)
      assert html =~ ~s(data-loading)
      assert html =~ ~s(data-part="item")
    end

    test "renders items with link redirect metadata" do
      items =
        Corex.Tree.new([
          %{label: "Patch", value: "p", to: "/p", redirect: :patch, new_tab: true},
          %{label: "Off", value: "o", redirect: false},
          %{label: "Nav", value: "n", to: "/n", redirect: :navigate}
        ])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <TreeView.tree_view id="tv-links" items={@items} redirect />
            """
          end,
          %{items: items}
        )

      assert html =~ ~s(data-redirect)
      assert html =~ ~s(data-new-tab)
    end
  end

  describe "compound errors" do
    test "raises when compound item is missing from ctx" do
      items = Corex.Tree.new([%{label: "Only", value: "only"}])

      missing = %Corex.Tree.Item{
        value: "missing",
        label: "Missing",
        children: [],
        disabled: false,
        to: nil,
        redirect: nil,
        new_tab: false,
        meta: %{}
      }

      assert_raise ArgumentError, ~r/not present in ctx.items/, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <TreeView.tree_view id="tv-bad-compound" compound :let={ctx} items={@items}>
              <TreeView.tree_view_root ctx={ctx}>
                <TreeView.tree_view_item ctx={ctx} item={@missing} />
              </TreeView.tree_view_root>
            </TreeView.tree_view>
            """
          end,
          %{items: items, missing: missing}
        )
      end
    end
  end
end
