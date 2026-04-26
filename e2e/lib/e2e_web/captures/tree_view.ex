defmodule CorexWeb.TreeView do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.TreeView

  @items E2e.TreeViewDemo.repo_tree()

  capture(
    variants: [
      basic: %{
        class: "tree-view",
        items: @items
      }
    ]
  )

  defdelegate tree_view(assigns), to: TreeView
end
