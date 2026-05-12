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
        value: "lib",
        children: [
          %{label: "tree_view.ex", value: "lib-tree-view-ex"},
          %{label: "tree_view_demo.ex", value: "lib-tree-view-demo-ex"}
        ]
      },
      %{
        label: "test",
        value: "test",
        children: [
          %{label: "tree_view_test.exs", value: "test-tree-view-test-exs"}
        ]
      },
      %{
        label: "assets",
        value: "assets",
        children: [
          %{label: "tree-view.ts", value: "assets-tree-view-ts"}
        ]
      },
      %{label: "mix.exs", value: "mix-exs"}
    ])
  end
end
