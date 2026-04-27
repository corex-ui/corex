defmodule E2eWeb.TreeViewTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.TreeViewModel, as: TreeView

  @tag :skip
  feature "anatomy — each section toggles first branch", %{session: session} do
    session =
      session
      |> TreeView.visit_ready("/en/tree-view/anatomy", css("#tree-view-anatomy-page"))
      |> TreeView.wait_section_tree_view_ready("tree-anatomy-minimal", timeout: 20_000)
      |> TreeView.prepare_lazy_tree_view()

    Enum.reduce(TreeView.anatomy_section_ids(), session, fn section_id, sess ->
      TreeView.assert_first_branch_toggles(sess, section_id)
    end)
  end

  @tag :skip
  feature "api — Expand lib expands lib branch", %{session: session} do
    session =
      session
      |> TreeView.visit_ready("/en/tree-view/api", css("#tree-view-api-page"))
      |> TreeView.wait_until_css_match_count(
        "#tree-view-api-set-expanded-client [data-part=branch-control]",
        timeout: 25_000
      )
      |> TreeView.prepare_lazy_tree_view()
      |> TreeView.wait(300)

    refute TreeView.lib_expanded_in?(session, "tree-api-set-expanded-client")

    session
    |> TreeView.click_expand_lib_api()
    |> TreeView.wait(1_500)

    assert TreeView.lib_expanded_in?(session, "tree-api-set-expanded-client")
  end

  @tag :skip
  feature "events — server tree view logs a row", %{session: session} do
    session =
      session
      |> TreeView.visit_ready("/en/tree-view/events", css("#tree-view-events-page"))
      |> TreeView.wait_until_css_match_count(
        "#tree-view-events-server [data-part=branch-control]",
        timeout: 25_000
      )
      |> TreeView.prepare_lazy_tree_view()
      |> TreeView.wait(400)

    refute TreeView.events_server_log_has_row?(session)

    session =
      session
      |> TreeView.click_events_server_first_branch()
      |> TreeView.wait(2_000)

    assert TreeView.events_server_log_has_row?(session)
  end
end
