defmodule E2eWeb.SwitchTest do
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
        Switch.click_control_in_section(session, section_id)
      end)
    end
  end

  describe "api" do
    feature "binding  -  Off via client binding", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Switch, :switch, :api)
      |> Switch.click_api_off()
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
      |> Switch.wait_for_has(
        css(
          "#switch-patterns-controlled [data-scope='switch'][data-part='root'][data-state='checked']",
          visible: :any
        ),
        timeout: 8_000
      )
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
