defmodule E2eWeb.NumberInputTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.NumberInputModel, as: NumberInput

  @moduletag :number_input

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal section increments hidden value", %{session: session} do
      section = "number-input-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :anatomy)
        |> NumberInput.wait_section_number_input_ready(section)

      before_value = NumberInput.hidden_value_in_section(session, section)

      session =
        session
        |> NumberInput.click_increment_in_section(section)

      after_value = NumberInput.hidden_value_in_section(session, section)
      assert after_value != before_value
    end
  end

  describe "api" do
    feature "set value binding updates hidden value", %{session: session} do
      section = "number-input-api-set-value-binding"
      host = "number-input-api-set-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready(host)
        |> NumberInput.click_button_in_section(section, "Set 42")

      assert NumberInput.hidden_value_at_host(session, host) in ["42", "42.0"]
    end

    feature "increment binding increases value", %{session: session} do
      section = "number-input-api-commands-binding"
      host = "number-input-api-cmd-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready(host)

      before = NumberInput.hidden_value_at_host(session, host)

      session = NumberInput.click_button_in_section(session, section, "+")

      after_value = NumberInput.hidden_value_at_host(session, host)
      assert after_value != before
    end

    feature "state server shows toast", %{session: session} do
      section = "number-input-api-state-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready("number-input-api-state-server")
        |> NumberInput.click_button_in_section(section, "Read state (server)")

      NumberInput.assert_toast(session, "number-input-api-state-server")
    end
  end

  describe "events" do
    feature "server  -  increment appends log row", %{session: session} do
      section = "number-input-events-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :events)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_section_number_input_ready(section)

      refute NumberInput.number_input_events_server_log_has_row?(session)

      session
      |> NumberInput.click_increment_in_section(section)
      |> NumberInput.wait_for_has(
        css("#number-input-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :playground)
      |> NumberInput.wait_playground_number_input_ready()
    end
  end

  describe "patterns" do
    feature "controlled  -  increment updates state text", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :patterns)
        |> NumberInput.wait_patterns_page()
        |> NumberInput.wait_root_number_input_ready("number-input-patterns-controlled-field")

      session
      |> NumberInput.click_increment_in_section("number-input-patterns-controlled-doc")
      |> NumberInput.wait_patterns_state_contains("11", timeout: 8_000)
    end
  end
end
