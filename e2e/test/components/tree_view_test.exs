defmodule E2eWeb.TreeViewTest do
  @moduledoc """
  TreeView Wallaby behavior regression.

  ## Behavior map

  | Page | Features |
  | --- | --- |
  | anatomy | Branch opens, assert data-state=open |
  | api | set_expanded x3 (binding, JS, server), expanded read (server toast) |
  | events | server log + client log grow, mention value |
  | patterns | page mounts |
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

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
      |> TreeView.wait_branch_content_open_in_host(host, "repo-lib", timeout: 8_000)
    end

    feature "set expanded (js)  -  Expand lib via CustomEvent opens branch", %{session: session} do
      host = "tree-api-set-expanded-js"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :api)
        |> TreeView.wait_host_tree_view_ready(host)

      refute TreeView.any_branch_content_open_in_host?(session, host)

      session
      |> TreeView.click_in_section("tree-view-api-set-expanded-js", "Expand lib")
      |> TreeView.wait_branch_content_open_in_host(host, "repo-lib", timeout: 8_000)
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
      |> TreeView.wait_branch_content_open_in_host(host, "repo-lib", timeout: 8_000)
    end

    feature "expanded (server)  -  Expanded shows toast", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :api)
        |> TreeView.prepare_live_form()
        |> TreeView.wait_host_tree_view_ready("tree-api-get-expanded-server")

      session
      |> TreeView.click_in_section("tree-view-api-get-expanded-server", "Expanded")
      |> TreeView.assert_toast("tree-api-get-expanded-server")
    end

    feature "set selected (binding)  -  Select leaf sets selection", %{session: session} do
      host = "tree-api-set-selected-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :api)
        |> TreeView.wait_host_tree_view_ready(host)

      session
      |> TreeView.click_in_section("tree-view-api-set-selected-client", "Select mix.exs")
      |> TreeView.wait_item_selected_in_host(host, "repo-mix", timeout: 8_000)
    end

    feature "set selected (js)  -  Select leaf via CustomEvent sets selection", %{
      session: session
    } do
      host = "tree-api-set-selected-js"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :api)
        |> TreeView.wait_host_tree_view_ready(host)

      session
      |> TreeView.click_in_section("tree-view-api-set-selected-js", "Select mix.exs")
      |> TreeView.wait_item_selected_in_host(host, "repo-mix", timeout: 8_000)
    end

    feature "set selected (server)  -  Select leaf via server sets selection", %{
      session: session
    } do
      host = "tree-api-set-selected-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :api)
        |> TreeView.prepare_live_form()
        |> TreeView.wait_host_tree_view_ready(host)

      session
      |> TreeView.click_in_section("tree-view-api-set-selected-server", "Select mix.exs")
      |> TreeView.wait_item_selected_in_host(host, "repo-mix", timeout: 8_000)
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

      session =
        session
        |> TreeView.click_first_branch_control_in_host("tree-events-server")
        |> TreeView.wait_log_rows_grew("tree-events-log-server", before, timeout: 10_000)

      TreeView.assert_events_log_mentions(session, "tree-events-log-server", "expanded")
    end

    feature "client  -  branch click appends client log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :events)
        |> TreeView.prepare_live_form()
        |> TreeView.wait_host_tree_view_ready("tree-events-client")

      before = TreeView.log_row_count(session, "tree-events-log-client")

      session =
        session
        |> TreeView.click_first_branch_control_in_host("tree-events-client")
        |> TreeView.wait_log_rows_grew("tree-events-log-client", before, timeout: 20_000)

      TreeView.assert_events_log_mentions(session, "tree-events-log-client", "expanded")
    end
  end

  describe "patterns" do
    feature "patterns page mounts", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :patterns)
      |> TreeView.wait_patterns_page()
    end
  end

  describe "keyboard focus and aria" do
    feature "arrows collapse and expand branch on anatomy minimal", %{session: session} do
      host = "tree-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(TreeView, :tree_view, :anatomy)
        |> TreeView.wait_host_tree_view_ready(host)
        |> TreeView.wait_branch_content_open_in_host(host, "lib", timeout: 8_000)
        |> TreeView.focus_branch_control(host, "lib")

      session =
        session
        |> TreeView.press_key_on_active(:left_arrow)

      TreeView.wait_branch_content_closed_in_host(session, host, "lib", timeout: 5_000)

      session =
        session
        |> TreeView.press_key_on_active(:right_arrow)

      TreeView.wait_branch_content_open_in_host(session, host, "lib", timeout: 5_000)
    end
  end
end
