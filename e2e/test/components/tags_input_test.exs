defmodule E2eWeb.TagsInputTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.TagsInputModel, as: TagsInput

  @moduletag :tags_input

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  comma adds a tag and delete removes it", %{session: session} do
      section = "tags-input-anatomy-minimal"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :anatomy)
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.focus_control_input_in_section(section)
      |> TagsInput.type_in_focused_input("gamma,")
      |> TagsInput.assert_item_text_in_section(section, "gamma", timeout: 8_000)
      |> TagsInput.click_delete_for_item_text_in_section(section, "gamma")
      |> TagsInput.refute_item_text_in_section(section, "gamma")
    end

    feature "with label  -  comma adds a tag and delete removes it", %{session: session} do
      section = "tags-input-anatomy-label"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :anatomy)
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.focus_control_input_in_section(section)
      |> TagsInput.type_in_focused_input("gamma,")
      |> TagsInput.assert_item_text_in_section(section, "gamma", timeout: 8_000)
      |> TagsInput.click_delete_for_item_text_in_section(section, "gamma")
      |> TagsInput.refute_item_text_in_section(section, "gamma")
    end
  end

  describe "api" do
    feature "client binding  -  Fill sets tags", %{session: session} do
      section = "tags-input-api-set-value-binding"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :api)
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.click_in_section(section, "Fill")
      |> TagsInput.assert_item_text_in_section(section, "lorem", timeout: 8_000)
      |> TagsInput.assert_item_text_in_section(section, "ipsum", timeout: 8_000)
    end

    feature "server  -  Fill from server sets tags", %{session: session} do
      section = "tags-input-api-set-value-server"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :api)
      |> TagsInput.prepare_live_form()
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.click_in_section(section, "Fill from server")
      |> TagsInput.assert_item_text_in_section(section, "lorem", timeout: 8_000)
      |> TagsInput.assert_item_text_in_section(section, "ipsum", timeout: 8_000)
    end

    feature "js dispatch  -  Fill via dispatch sets tags", %{session: session} do
      section = "tags-input-api-set-value-js"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :api)
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.click_in_section(section, "Fill via dispatch")
      |> TagsInput.assert_item_text_in_section(section, "lorem", timeout: 8_000)
      |> TagsInput.assert_item_text_in_section(section, "ipsum", timeout: 8_000)
    end

    feature "clear binding  -  Clear removes tags", %{session: session} do
      section = "tags-input-api-clear-binding"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :api)
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.assert_item_text_in_section(section, "a", timeout: 8_000)
      |> TagsInput.click_in_section(section, "Clear")
      |> TagsInput.refute_item_text_in_section(section, "a")
      |> TagsInput.refute_item_text_in_section(section, "b")
      |> TagsInput.refute_item_text_in_section(section, "c")
    end

    feature "clear server  -  Clear from server removes tags", %{session: session} do
      section = "tags-input-api-clear-server"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :api)
      |> TagsInput.prepare_live_form()
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.assert_item_text_in_section(section, "x", timeout: 8_000)
      |> TagsInput.click_in_section(section, "Clear from server")
      |> TagsInput.refute_item_text_in_section(section, "x")
      |> TagsInput.refute_item_text_in_section(section, "y")
    end

    feature "clear js  -  Clear via dispatch removes tags", %{session: session} do
      section = "tags-input-api-clear-js"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :api)
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.assert_item_text_in_section(section, "a", timeout: 8_000)
      |> TagsInput.click_in_section(section, "Clear via dispatch")
      |> TagsInput.refute_item_text_in_section(section, "a")
      |> TagsInput.refute_item_text_in_section(section, "b")
    end
  end

  describe "events" do
    feature "server  -  delete appends log row", %{session: session} do
      section = "tags-input-events-server-section"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :events)
      |> TagsInput.prepare_live_form()
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)

      refute TagsInput.tags_input_events_server_log_has_row?(session)

      session
      |> TagsInput.click_delete_for_item_text_in_section(section, "donec")
      |> TagsInput.wait_for_has(
        css("#tags-input-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert TagsInput.tags_input_events_server_log_has_row?(session)
    end

    feature "client  -  delete appends log row", %{session: session} do
      section = "tags-input-events-client-section"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :events)
      |> TagsInput.prepare_live_form()
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)

      refute TagsInput.tags_input_events_client_log_has_row?(session)

      session
      |> TagsInput.click_delete_for_item_text_in_section(section, "donec")
      |> TagsInput.wait_for_has(
        css("#tags-input-events-log-client tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert TagsInput.tags_input_events_client_log_has_row?(session)
    end
  end

  describe "patterns" do
    feature "controlled  -  delete updates chips", %{session: session} do
      section = "tags-input-patterns-controlled-section"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :patterns)
      |> TagsInput.wait_patterns_page()
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.assert_item_text_in_section(section, "duis", timeout: 8_000)
      |> TagsInput.click_delete_for_item_text_in_section(section, "duis")
      |> TagsInput.refute_item_text_in_section(section, "duis")
      |> TagsInput.assert_item_text_in_section(section, "lorem", timeout: 8_000)
    end

    feature "validation  -  disallowed tag is not kept", %{session: session} do
      section = "tags-input-patterns-validation-section"

      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :patterns)
      |> TagsInput.wait_patterns_page()
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 15_000)
      |> TagsInput.focus_control_input_in_section(section)
      |> TagsInput.type_in_focused_input("notallowed,")
      |> TagsInput.wait_section_tags_input_ready(section, timeout: 10_000)
      |> TagsInput.refute_item_text_in_section(section, "notallowed")
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(TagsInput, :tags_input, :playground)
      |> TagsInput.wait_playground_tags_input_ready(timeout: 15_000)
    end
  end
end
