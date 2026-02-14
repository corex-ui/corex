defmodule E2eWeb.TreeViewTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.TreeViewModel, as: TreeView

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - TreeView has no A11y violations", %{session: session} do
      session
      |> TreeView.goto(@mode)
      |> TreeView.check_accessibility()
    end
  end
end
