defmodule Corex.TreeViewTest do
  use ExUnit.Case, async: true

  alias Corex.TreeView
  alias Corex.TreeView.Connect

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
end
