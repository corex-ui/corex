defmodule E2eWeb.RadioGroupTest do
  @moduledoc """
  RadioGroup Wallaby behavior regression.

  ## Behavior map

  | Page | Features |
  | --- | --- |
  | anatomy | Click item, assert data-state=checked |
  | api | clear_value (binding), focus (binding), set_value (server), binding mounts, client JS dispatch |
  | events | server log + client log grow, mention value |
  | playground | hook mounts |
  | patterns | controlled selection |
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.RadioGroupModel, as: RadioGroup

  @moduletag :radio_group

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section selects an item by click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, RadioGroup, :radio_group, :anatomy)

      Enum.reduce(RadioGroup.anatomy_section_ids(), session, fn section_id, sess ->
        value = if section_id == "radio-group-anatomy-readonly", do: "lorem", else: "duis"

        sess
        |> RadioGroup.wait_section_radio_group_ready(section_id)
        |> RadioGroup.click_item_in_section(section_id, value)
        |> then(fn s ->
          assert RadioGroup.item_checked_in_section?(s, section_id, value)
          s
        end)
      end)
    end
  end

  describe "api" do
    feature "clear value (binding)  -  Clear deselects item", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :api)
        |> RadioGroup.wait_root_radio_group_ready("radio-group-api-clear")

      assert RadioGroup.item_checked_by_host_id?(session, "radio-group-api-clear", "lorem")

      session
      |> RadioGroup.click_button_in_section("radio-group-api-clear-section", "Clear")

      RadioGroup.wait_item_not_checked_by_host_id(session, "radio-group-api-clear", "lorem",
        timeout: 8_000
      )
    end

    feature "focus (binding)  -  Focus group moves focus into the radio group", %{
      session: session
    } do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :api)
        |> RadioGroup.wait_root_radio_group_ready("radio-group-api-focus")

      session
      |> RadioGroup.click_button_in_section("radio-group-api-focus-section", "Focus group")

      RadioGroup.assert_focus_inside(session, "radio-group-api-focus")
    end

    feature "set value (server)  -  Duis selects item", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :api)
        |> RadioGroup.prepare_live_form()
        |> RadioGroup.wait_root_radio_group_ready("radio-group-api-srv")

      refute RadioGroup.item_checked_by_host_id?(session, "radio-group-api-srv", "duis")

      session
      |> RadioGroup.click_button_in_section("radio-group-api-set-value-server", "Duis")

      RadioGroup.wait_item_checked_by_host_id(session, "radio-group-api-srv", "duis",
        timeout: 8_000
      )
    end

    feature "client binding section mounts radio group hook", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :api)
      |> RadioGroup.wait_root_radio_group_ready("radio-group-api-cb")
    end

    feature "client JS  -  dispatching custom event changes value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :api)
        |> RadioGroup.wait_root_radio_group_ready("radio-group-api-cjs")

      refute RadioGroup.item_checked_by_host_id?(session, "radio-group-api-cjs", "duis")

      RadioGroup.dispatch_set_value_js(session, "radio-group-api-cjs", "duis")

      RadioGroup.wait_item_checked_by_host_id(session, "radio-group-api-cjs", "duis",
        timeout: 8_000
      )
    end
  end

  describe "events" do
    feature "server  -  selection appends log row mentioning value", %{session: session} do
      section = "radio-group-events-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :events)
        |> RadioGroup.prepare_live_form()
        |> RadioGroup.wait_section_radio_group_ready(section)

      refute RadioGroup.radio_group_events_server_log_has_row?(session)

      before = RadioGroup.log_row_count(session, "radio-group-events-log-server")

      session =
        session
        |> RadioGroup.click_item_in_section(section, "b")
        |> RadioGroup.wait_log_rows_grew("radio-group-events-log-server", before, timeout: 10_000)

      RadioGroup.assert_events_log_mentions(session, "radio-group-events-log-server", "b")
    end

    feature "client  -  selection appends client log row mentioning value", %{session: session} do
      section = "radio-group-events-client-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :events)
        |> RadioGroup.prepare_live_form()
        |> RadioGroup.wait_section_radio_group_ready(section)

      refute RadioGroup.radio_group_events_client_log_has_row?(session)

      before = RadioGroup.log_row_count(session, "radio-group-events-log-client")

      session =
        session
        |> RadioGroup.click_item_in_section(section, "b")
        |> RadioGroup.wait_log_rows_grew("radio-group-events-log-client", before, timeout: 20_000)

      RadioGroup.assert_events_log_mentions(session, "radio-group-events-log-client", "b")
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :playground)
      |> RadioGroup.wait_playground_radio_group_ready()
    end
  end

  describe "patterns" do
    feature "controlled  -  selecting duis updates selection", %{session: session} do
      host = "patterns-radio-group-controlled"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :patterns)
        |> RadioGroup.wait_patterns_page()
        |> RadioGroup.wait_root_radio_group_ready(host)

      session
      |> RadioGroup.click_item_by_host_id(host, "duis")

      assert RadioGroup.item_checked_by_host_id?(session, host, "duis")
    end

    feature "dynamic  -  Add item then select it; Reset removes it", %{session: session} do
      section = "radio-group-patterns-dynamic"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :patterns)
        |> RadioGroup.wait_patterns_page()
        |> RadioGroup.wait_root_radio_group_ready("patterns-dynamic-0")

      session =
        session
        |> RadioGroup.click_button_in_section(section, "Add item")
        |> RadioGroup.wait_root_radio_group_ready("patterns-dynamic-1")
        |> RadioGroup.click_item_by_host_id("patterns-dynamic-1", "item-1")

      assert RadioGroup.item_checked_by_host_id?(session, "patterns-dynamic-1", "item-1")

      session
      |> RadioGroup.click_button_in_section(section, "Reset")
      |> RadioGroup.wait_root_radio_group_ready("patterns-dynamic-2")
      |> assert_has(
        css(
          ~s|#patterns-dynamic-2 [data-scope="radio-group"][data-part="item"][data-value="item-1"]|,
          count: 0,
          visible: :any
        )
      )
    end
  end

  describe "keyboard focus and aria" do
    feature "space selects focused item on anatomy minimal", %{session: session} do
      section = "radio-group-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :anatomy)
        |> RadioGroup.wait_section_radio_group_ready(section)
        |> RadioGroup.focus_item_in_section(section, "duis")

      refute RadioGroup.item_checked_in_section?(session, section, "duis")

      session = RadioGroup.press_key_on_active(session, :space)

      RadioGroup.wait_item_checked_in_section(session, section, "duis", timeout: 5_000)
      assert RadioGroup.item_checked_in_section?(session, section, "duis")
    end

    feature "arrows move checked selection on anatomy minimal", %{session: session} do
      section = "radio-group-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :anatomy)
        |> RadioGroup.wait_section_radio_group_ready(section)
        |> RadioGroup.click_item_in_section(section, "lorem")

      RadioGroup.wait_item_checked_in_section(session, section, "lorem", timeout: 5_000)

      session =
        session
        |> RadioGroup.focus_item_in_section(section, "lorem")
        |> RadioGroup.press_key_on_active(:down_arrow)

      RadioGroup.wait_item_checked_in_section(session, section, "duis", timeout: 5_000)
      assert RadioGroup.item_checked_in_section?(session, section, "duis")
      refute RadioGroup.item_checked_in_section?(session, section, "lorem")
    end
  end
end
