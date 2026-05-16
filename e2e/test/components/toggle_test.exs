defmodule E2eWeb.ToggleTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.ToggleModel, as: Toggle

  @moduletag :toggle

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  click toggles data-state", %{session: session} do
      section = "toggle-anatomy-minimal"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :anatomy)
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000)

      before = Toggle.toggle_root_data_state_in_section(session, section)
      assert before in ["on", "off"]

      session = Toggle.click_toggle_root_in_section(session, section)

      after_click = Toggle.toggle_root_data_state_in_section(session, section)
      assert after_click != before

      session = Toggle.click_toggle_root_in_section(session, section)
      assert Toggle.toggle_root_data_state_in_section(session, section) == before
    end

    feature "dual label  -  click swaps pressed state", %{session: session} do
      section = "toggle-anatomy-dual-label"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :anatomy)
      |> Toggle.wait_section_toggle_ready(section, hook_count: 2, timeout: 15_000)

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-anatomy-switching-label") ==
               "off"

      session =
        click(
          session,
          css(
            ~s|#toggle-anatomy-switching-label [data-scope="toggle"][data-part="root"]|,
            visible: :any
          )
        )

      session
      |> Toggle.wait_for_has(
        css(
          ~s|#toggle-anatomy-switching-label [data-scope="toggle"][data-part="root"][data-state="on"]|,
          visible: :any
        ),
        timeout: 8_000
      )

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-anatomy-switching-label") ==
               "on"
    end

    feature "indicator  -  click toggles data-state", %{session: session} do
      section = "toggle-anatomy-indicator"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :anatomy)
      |> Toggle.wait_section_toggle_ready(section, hook_count: 2, timeout: 15_000)

      before = Toggle.toggle_root_data_state_by_host_id(session, "toggle-anatomy-indicator-label")

      session =
        click(
          session,
          css(
            ~s|#toggle-anatomy-indicator-label [data-scope="toggle"][data-part="root"]|,
            visible: :any
          )
        )

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-anatomy-indicator-label") !=
               before
    end
  end

  describe "api" do
    feature "server  -  Pressed and Not pressed drive controlled toggle", %{session: session} do
      section = "toggle-api-server"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :api)
      |> Toggle.prepare_live_form()
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000)

      session
      |> Toggle.click_in_section(section, "Pressed")
      |> Toggle.wait_for_has(
        css(~s|#toggle-api-srv [data-scope="toggle"][data-part="root"][data-state="on"]|,
          visible: :any
        ),
        timeout: 8_000
      )

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-api-srv") == "on"

      session
      |> Toggle.click_in_section(section, "Not pressed")
      |> Toggle.wait_for_has(
        css(~s|#toggle-api-srv [data-scope="toggle"][data-part="root"][data-state="off"]|,
          visible: :any
        ),
        timeout: 8_000
      )

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-api-srv") == "off"
    end

    feature "client binding  -  Pressed and Not pressed set pressed", %{session: session} do
      section = "toggle-api-client-binding"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :api)
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000)

      session
      |> Toggle.click_in_section(section, "Pressed")
      |> Toggle.wait_for_has(
        css(~s|#toggle-api-bind [data-scope="toggle"][data-part="root"][data-state="on"]|,
          visible: :any
        ),
        timeout: 8_000
      )

      session
      |> Toggle.click_in_section(section, "Not pressed")
      |> Toggle.wait_for_has(
        css(~s|#toggle-api-bind [data-scope="toggle"][data-part="root"][data-state="off"]|,
          visible: :any
        ),
        timeout: 8_000
      )
    end

    feature "client js  -  Pressed and Not pressed dispatch set pressed", %{session: session} do
      section = "toggle-api-client-js"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :api)
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000)

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-api-cjs") == "on"

      session
      |> Toggle.click_in_section(section, "Not pressed")
      |> Toggle.wait_for_has(
        css(~s|#toggle-api-cjs [data-scope="toggle"][data-part="root"][data-state="off"]|,
          visible: :any
        ),
        timeout: 8_000
      )
    end
  end

  describe "events" do
    feature "server  -  click appends log row", %{session: session} do
      section = "toggle-events-server-section"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :events)
      |> Toggle.prepare_live_form()
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000)

      refute Toggle.toggle_events_server_log_has_row?(session)

      session
      |> Toggle.click_toggle_root_in_section(section)
      |> Toggle.wait_for_has(
        css("#toggle-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert Toggle.toggle_events_server_log_has_row?(session)
    end

    feature "client  -  click appends log row", %{session: session} do
      section = "toggle-events-client-section"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :events)
      |> Toggle.prepare_live_form()
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000)

      refute Toggle.toggle_events_client_log_has_row?(session)

      session
      |> Toggle.click_toggle_root_in_section(section)
      |> Toggle.wait_for_has(
        css("#toggle-events-log-client tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert Toggle.toggle_events_client_log_has_row?(session)
    end
  end

  describe "patterns" do
    feature "controlled  -  click toggles pressed root state", %{session: session} do
      section = "toggle-patterns-controlled-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :patterns)
        |> Toggle.wait_patterns_page()
        |> Toggle.wait_section_toggle_ready(section, timeout: 15_000)

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-patterns-controlled") ==
               "off"

      session
      |> Toggle.click_toggle_root_in_section(section)
      |> Toggle.wait_for_has(
        css(
          ~s|#toggle-patterns-controlled [data-scope="toggle"][data-part="root"][data-state="on"]|,
          visible: :any
        ),
        timeout: 8_000
      )

      assert Toggle.toggle_root_data_state_by_host_id(session, "toggle-patterns-controlled") ==
               "on"
    end
  end

  describe "playground" do
    feature "disabled switch sets data-disabled on toggle root", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :playground)
      |> Toggle.wait_playground_toggle_ready(timeout: 15_000)

      session
      |> Toggle.click_playground_disabled_switch()
      |> Toggle.wait_for_has(
        css(~s|#toggle-playground [data-scope="toggle"][data-part="root"][disabled]|,
          visible: :any
        ),
        timeout: 8_000
      )
    end
  end

  describe "style" do
    feature "color section mounts", %{session: session} do
      section = "toggle-styling-color"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :style)
      |> Toggle.wait_styling_page()
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000, hook_count: 6)
    end

    feature "disabled section shows data-disabled", %{session: session} do
      section = "toggle-styling-disabled"

      session
      |> ComponentBehaviorSpec.visit_ready(Toggle, :toggle, :style)
      |> Toggle.wait_styling_page()
      |> Toggle.wait_section_toggle_ready(section, timeout: 15_000, hook_count: 2)
      |> Toggle.wait_for_has(
        css(
          ~s|section##{section} [data-scope="toggle"][data-part="root"][data-disabled]|,
          count: 2,
          visible: :any
        ),
        timeout: 8_000
      )
    end
  end
end
