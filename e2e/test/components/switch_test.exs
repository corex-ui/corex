defmodule E2eWeb.SwitchTest do
  @moduledoc """
  Switch pilot Wallaby suite.

  | Page | Features |
  | --- | --- |
  | anatomy | Click flips `data-state` on root |
  | api | Binding Off sets unchecked; assert state |
  | events | Server log row after toggle |
  | playground | Host ready without data-loading |
  | patterns | Controlled click → checked |
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.SwitchModel, as: Switch

  @moduletag :switch

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section toggles control by click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Switch, :switch, :anatomy)

      Enum.each(Switch.anatomy_section_ids(), fn section_id ->
        before = Switch.root_data_state_in_section(session, section_id)
        expected = if before == "checked", do: "unchecked", else: "checked"

        session
        |> Switch.click_control_in_section(section_id)
        |> Switch.wait_root_data_state_in_section(section_id, expected, timeout: 8_000)
      end)
    end
  end

  describe "api" do
    feature "binding  -  Off via client binding", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :api)
      |> Switch.wait_switch_host_ready("switch-api-cb")
      |> Switch.click_api_on()
      |> Switch.wait_root_data_state("switch-api-cb", "checked", timeout: 8_000)
      |> Switch.click_api_off()
      |> Switch.wait_root_data_state("switch-api-cb", "unchecked", timeout: 8_000)
    end

    feature "js  -  On via CustomEvent", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :api)
      |> Switch.wait_switch_host_ready("switch-api-cjs")
      |> Switch.click_api_js_on()
      |> Switch.wait_root_data_state("switch-api-cjs", "checked", timeout: 8_000)
    end

    feature "server  -  On via push_event", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :api)
      |> Switch.wait_switch_host_ready("switch-api-srv")
      |> Switch.click_api_server_on()
      |> Switch.wait_root_data_state("switch-api-srv", "checked", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  switch interaction produces log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :events)

      refute Switch.switch_events_server_log_has_row?(session)

      session
      |> Switch.click_control_in_section("switch-events-server")
      |> Switch.wait_for_has(
        css("#switch-events-log-server tr[data-part='row']"),
        timeout: 10_000
      )
    end

    feature "client  -  switch interaction produces log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :events)

      refute Switch.switch_events_client_log_has_row?(session)

      session
      |> Switch.click_control_in_section("switch-events-client")
      |> Switch.wait_for_has(
        css("#switch-events-log-client tr[data-part='row']"),
        timeout: 10_000
      )
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :playground)
      |> Switch.wait_playground_switch_ready()
    end
  end

  describe "patterns" do
    feature "controlled  -  click enables checked root state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :patterns)
        |> Switch.wait_patterns_page()

      session
      |> Switch.click_control_in_section("switch-patterns-controlled-section")
      |> Switch.wait_root_data_state("switch-patterns-controlled", "checked", timeout: 8_000)
    end
  end

  describe "keyboard focus and aria" do
    feature "space toggles data-state on anatomy minimal", %{session: session} do
      section = "switch-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :anatomy)
        |> Switch.wait_switch_host_ready(section)
        |> Switch.focus_control_in_section(section)

      before = Switch.root_data_state_in_section(session, section)
      expected = if before == "checked", do: "unchecked", else: "checked"

      session =
        session
        |> Switch.press_key_on_active(:space)

      Switch.wait_root_data_state_in_section(session, section, expected, timeout: 5_000)
    end
  end

  describe "a11y (post-interaction, scoped, theme and mode matrix)" do
    @moduletag :switch_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground switch passes axe for each theme and mode after toggle", %{
      session: session
    } do
      {path, ready_sel} = ComponentBehaviorSpec.page(:switch, :playground)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(path, css(ready_sel), theme, mode)
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> Switch.wait_playground_switch_ready()

          sess =
            Switch.check_accessibility(sess, css("#switch-playground"),
              filter: E2eWeb.A11yDocPageFilter
            )

          sess
          |> Switch.click_playground_switch_control()
          |> Switch.wait(200)
          |> then(
            &Switch.check_accessibility(&1, css("#switch-playground"),
              filter: E2eWeb.A11yDocPageFilter
            )
          )
      end
    end
  end
end
