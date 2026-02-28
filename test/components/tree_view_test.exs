defmodule Corex.TreeViewTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.TreeView
  alias Corex.TreeView.Connect

  describe "tree_view/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_tree_view/1, [])
      assert html =~ ~r/data-scope="tree-view"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/Item/
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

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-tree", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "tree-view:test-tree"
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
      assert result["id"] == "tree-view:test-tree:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.tree/1" do
    test "returns tree attributes" do
      assigns = %{id: "test-tree", dir: "ltr"}
      result = Connect.tree(assigns)
      assert result["id"] == "tree-view:test-tree:tree"
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
      assert result["id"] == "tree-view:test-tree:item:node-1"
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

    test "adds hidden when collapsed" do
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
      assert result["data-default-expanded-value"] == "node-1"
      assert result["data-default-selected-value"] == "node-2"
      assert result["data-expanded-value"] == nil
      assert result["data-selected-value"] == nil
    end

    test "returns props when controlled" do
      assigns = %{
        id: "test-tree",
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
      assert result["data-default-expanded-value"] == nil
      assert result["data-default-selected-value"] == nil
      assert result["data-expanded-value"] == "node-1"
      assert result["data-selected-value"] == "node-2"
    end
  end
end
