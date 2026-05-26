defmodule E2eWeb.TabsTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

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
    feature "client binding  -  Duis selects tab", %{session: session} do
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

    feature "server  -  Duis selects tab", %{session: session} do
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
    feature "server  -  tab change appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tabs, :tabs, :events)
        |> Tabs.prepare_live_form()
        |> Tabs.wait_host_tabs_ready("tabs-events-server")

      refute Tabs.tabs_events_server_log_has_row?(session)

      session
      |> Tabs.click_trigger_by_label_in_host("tabs-events-server", "Duis")
      |> Tabs.wait_for_has(css("#tabs-events-log-server tr[data-part='row']"), timeout: 10_000)

      assert Tabs.tabs_events_server_log_has_row?(session)
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
end
