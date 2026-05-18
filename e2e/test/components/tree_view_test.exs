defmodule E2eWeb.TreeViewTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.TreeViewModel, as: TreeView

  @moduletag :tree_view

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  first branch expands", %{session: session} do
      host = "tree-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :anatomy)
        |> TreeView.wait_host_tree_view_ready(host)
        |> TreeView.wait_any_branch_content_open_in_host(host, timeout: 8_000)

      assert TreeView.any_branch_content_open_in_host?(session, host)
    end

    feature "with indicator  -  first branch expands", %{session: session} do
      host = "tree-with-indicator"

      session
      |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :anatomy)
      |> TreeView.wait_host_tree_view_ready(host)
      |> TreeView.wait_any_branch_content_open_in_host(host, timeout: 8_000)
    end
  end

  describe "api" do
    feature "set expanded (binding)  -  Expand lib opens branch", %{session: session} do
      host = "tree-api-set-expanded-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :api)
        |> TreeView.wait_host_tree_view_ready(host)

      refute TreeView.any_branch_content_open_in_host?(session, host)

      session
      |> TreeView.click_in_section("tree-view-api-set-expanded-client", "Expand lib")
      |> TreeView.wait_any_branch_content_open_in_host(host, timeout: 8_000)
    end

    feature "set expanded (server)  -  Expand lib opens branch", %{session: session} do
      host = "tree-api-set-expanded-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :api)
        |> TreeView.prepare_live_form()
        |> TreeView.wait_host_tree_view_ready(host)

      session
      |> TreeView.click_in_section("tree-view-api-set-expanded-server", "Expand lib")
      |> TreeView.wait_any_branch_content_open_in_host(host, timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  branch click appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :events)
        |> TreeView.prepare_live_form()
        |> TreeView.wait_host_tree_view_ready("tree-events-server")

      before = TreeView.log_row_count(session, "tree-events-log-server")

      session
      |> TreeView.click_first_branch_control_in_host("tree-events-server")
      |> TreeView.wait_for_has(
        css("#tree-events-log-server tr[data-part='row']", count: before + 1),
        timeout: 10_000
      )

      assert TreeView.tree_view_events_server_log_has_row?(session)
    end
  end

  describe "patterns" do
    feature "patterns page mounts", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :patterns)
      |> TreeView.wait_patterns_page()
    end
  end
end
