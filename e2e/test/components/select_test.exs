defmodule E2eWeb.SelectTest do
  @moduledoc """
  Select Wallaby behavior regression.

  ## Behavior map

  | Page | Features |
  | --- | --- |
  | anatomy | Open + click item in each section, assert hidden value |
  | api | set_value x3 (binding, JS, server), assert hidden input |
  | events | server log + client log grow, mention value |
  | playground | hook mounts |
  | patterns | controlled selection |
  """

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

    feature "set value (js)  -  France via CustomEvent", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :api)
        |> Select.wait_root_select_ready("select-api-cjs")

      refute Select.hidden_input_value_by_host_id(session, "select-api-cjs") == "fra"

      session
      |> Select.click_button_in_section("select-api-set-value-client-js", "France")

      Select.wait_hidden_value_by_host_id(session, "select-api-cjs", "fra", timeout: 8_000)
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
    feature "server  -  selection appends log row mentioning value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :events)
        |> Select.prepare_live_form()
        |> Select.wait_root_select_ready("select-events-server")

      refute Select.select_events_server_log_has_row?(session)

      before = Select.log_row_count(session, "select-events-log-server")

      session =
        session
        |> Select.open_select_by_host_id("select-events-server")
        |> Select.click_item_by_host_id("select-events-server", "bel")
        |> Select.wait_log_rows_grew("select-events-log-server", before, timeout: 10_000)

      Select.assert_events_log_mentions(session, "select-events-log-server", "bel")
    end

    feature "client  -  selection appends client log row mentioning value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :events)
        |> Select.prepare_live_form()
        |> Select.wait_root_select_ready("select-events-client")

      refute Select.select_events_client_log_has_row?(session)

      before = Select.log_row_count(session, "select-events-log-client")

      session =
        session
        |> Select.open_select_by_host_id("select-events-client")
        |> Select.click_item_by_host_id("select-events-client", "bel")
        |> Select.wait_log_rows_grew("select-events-log-client", before, timeout: 20_000)

      Select.assert_events_log_mentions(session, "select-events-log-client", "bel")
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

    feature "dynamic  -  Add item then Reset restores item set", %{session: session} do
      section = "select-patterns-dynamic-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :patterns)
        |> Select.wait_patterns_page()
        |> Select.wait_root_select_ready("patterns-dynamic")

      session =
        session
        |> Select.click_button_in_section(section, "Add item")
        |> Select.wait_root_select_ready("patterns-dynamic")
        |> Select.open_select_by_host_id("patterns-dynamic")
        |> Select.click_item_by_host_id("patterns-dynamic", "item-1")
        |> Select.wait_hidden_value_by_host_id("patterns-dynamic", "item-1", timeout: 8_000)

      session
      |> Select.click_button_in_section(section, "Reset")
      |> Select.wait_root_select_ready("patterns-dynamic")
      |> assert_has(
        css(
          ~S|#patterns-dynamic [data-scope="select"][data-part="item"][data-value="item-1"]|,
          count: 0,
          visible: :any
        )
      )
    end
  end

  describe "keyboard focus and aria" do
    feature "space opens the select trigger on anatomy minimal", %{session: session} do
      section = "select-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
        |> Select.wait_section_select_ready(section)
        |> Select.focus_trigger_in_section(section)

      refute Select.content_open_in_section?(session, section)

      session = Select.press_key_on_active(session, :space)

      assert Select.content_open_in_section?(session, section)
    end

    feature "enter opens the select trigger on anatomy minimal", %{session: session} do
      section = "select-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
        |> Select.wait_section_select_ready(section)
        |> Select.focus_trigger_in_section(section)

      session = Select.press_key_on_active(session, :enter)

      assert Select.content_open_in_section?(session, section)
    end

    feature "arrows move highlight through items on anatomy minimal", %{session: session} do
      section = "select-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
        |> Select.wait_section_select_ready(section)
        |> Select.focus_trigger_in_section(section)
        |> Select.press_key_on_active(:space)

      Select.wait_for_has(
        session,
        css(
          ~s|section##{section} [data-scope="select"][data-part="content"][data-state="open"]|,
          visible: :any
        ),
        timeout: 5_000
      )

      # Zag highlights the first item on open; Down moves to the next.
      session
      |> Select.assert_highlighted_item_in_section(section, "fra")
      |> Select.press_key_on_active(:down_arrow)
      |> Select.assert_highlighted_item_in_section(section, "bel")
    end

    feature "escape closes open select on anatomy minimal", %{session: session} do
      section = "select-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
        |> Select.wait_section_select_ready(section)
        |> Select.focus_trigger_in_section(section)
        |> Select.press_key_on_active(:space)

      assert Select.content_open_in_section?(session, section)

      session = Select.press_key_on_active(session, :escape)

      refute Select.content_open_in_section?(session, section)
    end

    feature "enter selects highlighted item on anatomy minimal", %{session: session} do
      section = "select-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
        |> Select.wait_section_select_ready(section)
        |> Select.focus_trigger_in_section(section)
        |> Select.press_key_on_active(:space)

      Select.wait_for_has(
        session,
        css(
          ~s|section##{section} [data-scope="select"][data-part="content"][data-state="open"]|,
          visible: :any
        ),
        timeout: 5_000
      )

      session
      |> Select.assert_highlighted_item_in_section(section, "fra")
      |> Select.press_key_on_active(:enter)

      Select.wait_hidden_value_in_anatomy_section(session, section, "fra", timeout: 5_000)
    end

    feature "click focuses the trigger on anatomy minimal", %{session: session} do
      section = "select-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
        |> Select.wait_section_select_ready(section)
        |> Select.open_select_in_anatomy_section(section)

      assert Select.content_open_in_section?(session, section)
    end

    feature "trigger has aria-controls pointing to content", %{session: session} do
      host = "select-anatomy-minimal"

      session
      |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
      |> Select.wait_section_select_ready(host)
      |> Select.assert_trigger_has_aria_controls(host)
    end

    feature "scoped axe after keyboard open on anatomy minimal", %{session: session} do
      section = "select-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Select, :select, :anatomy)
        |> Select.wait_section_select_ready(section)
        |> Select.focus_trigger_in_section(section)
        |> Select.press_key_on_active(:space)

      Select.wait_for_has(
        session,
        css(
          ~s|section##{section} [data-scope="select"][data-part="content"][data-state="open"]|,
          visible: :any
        ),
        timeout: 5_000
      )

      session = Select.wait(session, 400)

      Select.check_accessibility(session, css("##{section}"), filter: E2eWeb.A11yDocPageFilter)
    end
  end
end
