defmodule E2e.TreeViewDemo do
  @moduledoc false

  def repo_expanded_default do
    ["corex", "lib"]
  end

  def repo_selected_default, do: ["lib-tree-view-ex"]

  def repo_tree do
    Corex.Tree.new([
      %{
        label: "lib",
        id: "lib",
        children: [
          %{label: "tree_view.ex", id: "lib-tree-view-ex"},
          %{label: "tree_view_demo.ex", id: "lib-tree-view-demo-ex"}
        ]
      },
      %{
        label: "test",
        id: "test",
        children: [
          %{label: "tree_view_test.exs", id: "test-tree-view-test-exs"}
        ]
      },
      %{
        label: "assets",
        id: "assets",
        children: [
          %{label: "tree-view.ts", id: "assets-tree-view-ts"}
        ]
      },
      %{label: "mix.exs", id: "mix-exs"}
    ])
  end
end
