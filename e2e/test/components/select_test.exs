defmodule E2eWeb.SelectTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.SelectModel, as: Select

  @moduletag :select

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section can select Belgium by click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Select, :select, :anatomy)

      _ =
        Enum.reduce(Select.anatomy_section_ids(), session, fn section_id, sess ->
          sess
          |> Select.wait_section_select_ready(section_id)
          |> Select.open_select_in_anatomy_section(section_id)
          |> Select.click_item_in_anatomy_section(section_id, "bel")
          |> Select.wait_hidden_value_in_anatomy_section(section_id, "bel", timeout: 8_000)
        end)
    end
  end

  describe "api" do
    feature "set value (binding)  -  France selects fra", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :api)
        |> Select.wait_root_select_ready("select-api-cb")

      refute Select.hidden_input_value_by_host_id(session, "select-api-cb") == "fra"

      session
      |> Select.click_button_in_section("select-api-set-value-client-binding", "France")

      Select.wait_hidden_value_by_host_id(session, "select-api-cb", "fra", timeout: 8_000)
    end

    feature "set value (server)  -  France via LiveView", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :api)
        |> Select.prepare_live_form()
        |> Select.wait_root_select_ready("select-api-srv")

      refute Select.hidden_input_value_by_host_id(session, "select-api-srv") == "fra"

      session
      |> Select.click_button_in_section("select-api-set-value-server", "France")

      Select.wait_hidden_value_by_host_id(session, "select-api-srv", "fra", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  selection appends a log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :events)
        |> Select.prepare_live_form()
        |> Select.wait_root_select_ready("select-events-server")

      refute Select.select_events_server_log_has_row?(session)

      session
      |> Select.open_select_by_host_id("select-events-server")
      |> Select.click_item_by_host_id("select-events-server", "bel")
      |> Select.wait_for_has(css("#select-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Select, :select, :playground)
      |> Select.wait_playground_select_ready()
    end
  end

  describe "patterns" do
    feature "controlled  -  France updates controlled value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :patterns)
        |> Select.wait_patterns_page()
        |> Select.wait_root_select_ready("select-patterns-controlled")

      session
      |> Select.open_select_by_host_id("select-patterns-controlled")
      |> Select.click_item_by_host_id("select-patterns-controlled", "fra")
      |> Select.wait_hidden_value_by_host_id("select-patterns-controlled", "fra", timeout: 8_000)
    end
  end
end
