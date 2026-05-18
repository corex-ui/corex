defmodule E2eWeb.RadioGroupTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

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
    feature "server  -  Set Duis selects item", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :api)
        |> RadioGroup.prepare_live_form()
        |> RadioGroup.wait_root_radio_group_ready("radio-group-api-server")

      refute RadioGroup.item_checked_by_host_id?(session, "radio-group-api-server", "duis")

      session
      |> RadioGroup.click_button_in_section("radio-group-api-server-section", "Set Duis")

      assert RadioGroup.item_checked_by_host_id?(session, "radio-group-api-server", "duis")
    end

    feature "binding section mounts radio group hook", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :api)
      |> RadioGroup.wait_root_radio_group_ready("radio-group-api-binding")
    end
  end

  describe "events" do
    feature "server  -  selection appends log row", %{session: session} do
      section = "radio-group-events-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(RadioGroup, :radio_group, :events)
        |> RadioGroup.prepare_live_form()
        |> RadioGroup.wait_section_radio_group_ready(section)

      refute RadioGroup.radio_group_events_server_log_has_row?(session)

      session
      |> RadioGroup.click_item_in_section(section, "b")
      |> RadioGroup.wait_for_has(
        css("#radio-group-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )
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
  end
end
