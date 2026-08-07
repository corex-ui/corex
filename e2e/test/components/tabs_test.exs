defmodule E2eWeb.TabsTest do
  @moduledoc """
  Tabs Wallaby behavior regression.

  ## Behavior map

  | Page | Features |
  | --- | --- |
  | anatomy | Click trigger, assert data-selected |
  | api | set_value x3 (binding, JS, server), assert trigger selected |
  | events | server log + client log grow, mention value |
  | patterns | controlled tab switch |
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.TabsModel, as: Tabs

  @moduletag :tabs

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "basic  -  Duis tab becomes selected", %{session: session} do
      host = "tabs-basic"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :anatomy)
        |> Tabs.wait_host_tabs_ready(host)
        |> Tabs.click_trigger_by_label_in_host(host, "Duis")
        |> Tabs.wait_trigger_selected_by_label_in_host(host, "Duis", timeout: 8_000)

      assert Tabs.trigger_selected_by_label_in_host?(session, host, "Duis")
    end

    feature "nested  -  inner Duis tab becomes selected", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :anatomy)
        |> Tabs.wait_host_tabs_ready("tabs-nested-outer")
        |> Tabs.click_trigger_by_label_in_host("tabs-nested-outer", "Outer 2")
        |> Tabs.wait_host_tabs_ready("tabs-nested-inner")
        |> Tabs.click_trigger_by_label_in_host("tabs-nested-inner", "Duis")
        |> Tabs.wait_trigger_selected_by_label_in_host("tabs-nested-inner", "Duis",
          timeout: 8_000
        )

      assert Tabs.trigger_selected_by_label_in_host?(session, "tabs-nested-inner", "Duis")
    end
  end

  describe "api" do
    feature "set value (binding)  -  Duis selects tab", %{session: session} do
      host = "tabs-api-cb"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :api)
        |> Tabs.wait_host_tabs_ready(host)

      refute Tabs.trigger_selected_by_label_in_host?(session, host, "Duis")

      session
      |> Tabs.click_in_section("tabs-api-set-value-client-binding", "Duis")
      |> Tabs.wait_trigger_selected_by_label_in_host(host, "Duis", timeout: 8_000)
    end

    feature "set value (js)  -  Lorem via CustomEvent selects tab", %{session: session} do
      host = "tabs-api-cjs"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :api)
        |> Tabs.wait_host_tabs_ready(host)

      session
      |> Tabs.click_in_section("tabs-api-set-value-client-js", "Lorem")
      |> Tabs.wait_trigger_selected_by_label_in_host(host, "Lorem", timeout: 8_000)
    end

    feature "set value (server)  -  Duis selects tab", %{session: session} do
      host = "tabs-api-srv"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :api)
        |> Tabs.prepare_live_form()
        |> Tabs.wait_host_tabs_ready(host)

      session
      |> Tabs.click_in_section("tabs-api-set-value-server", "Duis")
      |> Tabs.wait_trigger_selected_by_label_in_host(host, "Duis", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  tab change appends log row mentioning value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :events)
        |> Tabs.prepare_live_form()
        |> Tabs.wait_host_tabs_ready("tabs-events-server")

      refute Tabs.tabs_events_server_log_has_row?(session)

      before = Tabs.log_row_count(session, "tabs-events-log-server")

      session =
        session
        |> Tabs.click_trigger_by_label_in_host("tabs-events-server", "Duis")
        |> Tabs.wait_log_rows_grew("tabs-events-log-server", before, timeout: 10_000)

      Tabs.assert_events_log_mentions(session, "tabs-events-log-server", "duis")
    end

    feature "client  -  tab change appends client log row mentioning value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :events)
        |> Tabs.prepare_live_form()
        |> Tabs.wait_host_tabs_ready("tabs-events-client")

      refute Tabs.tabs_events_client_log_has_row?(session)

      before = Tabs.log_row_count(session, "tabs-events-log-client")

      session =
        session
        |> Tabs.click_trigger_by_label_in_host("tabs-events-client", "Duis")
        |> Tabs.wait_log_rows_grew("tabs-events-log-client", before, timeout: 20_000)

      Tabs.assert_events_log_mentions(session, "tabs-events-log-client", "duis")
    end
  end

  describe "patterns" do
    feature "controlled  -  Duis updates selected tab", %{session: session} do
      host = "tabs-patterns-controlled"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :patterns)
        |> Tabs.wait_patterns_page()
        |> Tabs.wait_host_tabs_ready(host)

      assert Tabs.trigger_selected_by_label_in_host?(session, host, "Lorem")

      session
      |> Tabs.click_trigger_by_label_in_host(host, "Duis")
      |> Tabs.wait_trigger_selected_by_label_in_host(host, "Duis", timeout: 8_000)
    end
  end

  describe "keyboard focus and aria" do
    feature "arrows move selected tab on anatomy basic", %{session: session} do
      host = "tabs-basic"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :anatomy)
        |> Tabs.wait_host_tabs_ready(host)
        |> Tabs.focus_trigger_by_value(host, "lorem")

      assert Tabs.trigger_selected_by_label_in_host?(session, host, "Lorem")

      session =
        session
        |> Tabs.press_key_on_active(:right_arrow)

      Tabs.wait_trigger_selected_by_label_in_host(session, host, "Duis", timeout: 5_000)
      assert Tabs.trigger_selected_by_label_in_host?(session, host, "Duis")

      session =
        session
        |> Tabs.press_key_on_active(:left_arrow)

      Tabs.wait_trigger_selected_by_label_in_host(session, host, "Lorem", timeout: 5_000)
      assert Tabs.trigger_selected_by_label_in_host?(session, host, "Lorem")
    end
  end
end
