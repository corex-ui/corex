defmodule E2eWeb.CheckboxTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.CheckboxModel, as: Checkbox
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :checkbox

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section toggles control to checked", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :anatomy)

      Enum.reduce(Checkbox.anatomy_section_ids(), session, fn section_id, sess ->
        sess =
          sess
          |> Checkbox.click_control_in_section(section_id)
          |> Checkbox.wait_for_has(
            css("##{section_id} [data-part='control'][data-state='checked']", visible: :any),
            timeout: 8_000
          )

        assert Checkbox.control_data_state(sess, section_id) == "checked"
        sess
      end)
    end

    feature "minimal  -  Space toggles checked state", %{session: session} do
      section = "checkbox-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :anatomy)
        |> Checkbox.click_control_in_section(section)

      assert Checkbox.control_data_state(session, section) == "checked"

      session =
        session
        |> Checkbox.press_space_on_checkbox_control(section)

      assert Checkbox.control_data_state(session, section) == "unchecked"
    end
  end

  describe "api" do
    feature "binding  -  Set unchecked updates control state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :api)
        |> Checkbox.click_in_section("checkbox-api-client-binding", "Set checked")

      assert Checkbox.control_data_state(session, "checkbox-api-bind") == "checked"

      session
      |> Checkbox.click_api_set_unchecked()

      assert Checkbox.control_data_state(session, "checkbox-api-bind") == "unchecked"
    end

    feature "client js  -  Dispatch checked updates control state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :api)
        |> Checkbox.click_api_dispatch_checked()

      assert Checkbox.control_data_state(session, "checkbox-api-dispatch") == "checked"
    end

    feature "server  -  Set checked updates control state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :api)
        |> Checkbox.click_api_server_set_checked()

      assert Checkbox.control_data_state(session, "checkbox-api-server") == "checked"
    end
  end

  describe "events" do
    feature "server  -  interactions append log rows", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :events)
        |> Checkbox.prepare_live_form()

      refute Checkbox.checkbox_events_server_log_has_row?(session)

      session
      |> Checkbox.click_control_in_section("checkbox-events-server")
      |> Checkbox.wait_for_has(
        css("#checkbox-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert Checkbox.checkbox_events_server_log_has_row?(session)
    end

    feature "client  -  interaction logs client row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :events)
        |> Checkbox.prepare_live_form()

      refute Checkbox.checkbox_events_client_log_has_row?(session)

      session
      |> Checkbox.click_events_client_checkbox()
      |> Checkbox.wait_for_has(
        css("#checkbox-events-log-client tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert Checkbox.checkbox_events_client_log_has_row?(session)
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :playground)
      |> Checkbox.wait_playground_checkbox_ready()
    end
  end

  describe "patterns" do
    feature "patterns doc page is ready", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :patterns)
      |> Checkbox.wait_patterns_page()
    end
  end

  describe "a11y (post-interaction, scoped, theme and mode matrix)" do
    @moduletag :checkbox_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground checkbox passes axe for each theme and mode after toggle", %{
      session: session
    } do
      {path, ready_sel} = ComponentBehaviorSpec.page(:checkbox, :playground)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(path, css(ready_sel), theme, mode)
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> Checkbox.wait_playground_checkbox_ready()

          sess =
            Checkbox.check_accessibility(sess, css("#checkbox-playground"),
              filter: E2eWeb.A11yDocPageFilter
            )

          sess
          |> Checkbox.click_playground_checkbox_control()
          |> Checkbox.wait(200)
          |> then(
            &Checkbox.check_accessibility(&1, css("#checkbox-playground"),
              filter: E2eWeb.A11yDocPageFilter
            )
          )
      end
    end
  end
end
