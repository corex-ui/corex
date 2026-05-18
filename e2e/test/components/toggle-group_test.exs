defmodule E2eWeb.ToggleGroupTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.ToggleGroupModel, as: ToggleGroup

  @moduletag :toggle_group

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  Duis item toggles on", %{session: session} do
      host = "toggle-group-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(ToggleGroup, :toggle_group, :anatomy)
        |> ToggleGroup.wait_section_toggle_group_ready("toggle-group-anatomy-minimal")
        |> ToggleGroup.click_item_by_value_in_host(host, "duis")
        |> ToggleGroup.wait_item_on_in_host(host, "duis", timeout: 8_000)

      assert ToggleGroup.item_on_in_host?(session, host, "duis")
    end

    feature "indicator  -  bold item toggles on", %{session: session} do
      host = "toggle-group-anatomy-indicator-label"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(ToggleGroup, :toggle_group, :anatomy)
        |> ToggleGroup.wait_section_toggle_group_ready("toggle-group-anatomy-indicator")
        |> ToggleGroup.click_item_by_value_in_host(host, "bold")
        |> ToggleGroup.wait_item_on_in_host(host, "bold", timeout: 8_000)

      assert ToggleGroup.item_on_in_host?(session, host, "bold")
    end
  end

  describe "api" do
    feature "client binding  -  Duis selects item", %{session: session} do
      host = "toggle-group-api-cb"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(ToggleGroup, :toggle_group, :api)
        |> ToggleGroup.wait_host_toggle_group_ready(host)

      refute ToggleGroup.item_on_in_host?(session, host, "duis")

      session
      |> ToggleGroup.click_in_section("toggle-group-api-set-value-client-binding", "Duis")
      |> ToggleGroup.wait_item_on_in_host(host, "duis", timeout: 8_000)
    end

    feature "server  -  Donec selects item", %{session: session} do
      host = "toggle-group-api-srv"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(ToggleGroup, :toggle_group, :api)
        |> ToggleGroup.prepare_live_form()
        |> ToggleGroup.wait_host_toggle_group_ready(host)

      session
      |> ToggleGroup.click_in_section("toggle-group-api-set-value-server", "Donec")
      |> ToggleGroup.wait_item_on_in_host(host, "donec", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  item click appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(ToggleGroup, :toggle_group, :events)
        |> ToggleGroup.prepare_live_form()
        |> ToggleGroup.wait_host_toggle_group_ready("toggle-group-events-server")

      refute ToggleGroup.toggle_group_events_server_log_has_row?(session)

      session
      |> ToggleGroup.click_item_by_value_in_host("toggle-group-events-server", "duis")
      |> ToggleGroup.wait_for_has(
        css("#toggle-group-events-log-server tr[data-part='row']"),
        timeout: 10_000
      )

      assert ToggleGroup.toggle_group_events_server_log_has_row?(session)
    end
  end

  describe "patterns" do
    feature "controlled  -  Duis updates selection", %{session: session} do
      host = "toggle-group-patterns-controlled"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(ToggleGroup, :toggle_group, :patterns)
        |> ToggleGroup.wait_patterns_page()
        |> ToggleGroup.wait_host_toggle_group_ready(host)

      session
      |> ToggleGroup.click_item_by_value_in_host(host, "duis")
      |> ToggleGroup.wait_item_on_in_host(host, "duis", timeout: 8_000)
    end
  end
end
