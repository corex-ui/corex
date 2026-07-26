defmodule E2eWeb.NumberInputTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

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

    feature "set value (js)  -  Set 7 updates hidden value", %{session: session} do
      section = "number-input-api-set-value-js"
      host = "number-input-api-set-js"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready(host)
        |> NumberInput.click_button_in_section(section, "Set 7")

      assert NumberInput.hidden_value_at_host(session, host) in ["7", "7.0"]
    end

    feature "set value (server)  -  Set 99 updates hidden value", %{session: session} do
      section = "number-input-api-set-value-server"
      host = "number-input-api-set-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready(host)
        |> NumberInput.click_button_in_section(section, "Set 99")

      assert NumberInput.hidden_value_at_host(session, host) in ["99", "99.0"]
    end

    feature "clear (binding)  -  Clear empties value", %{session: session} do
      section = "number-input-api-clear-binding"
      host = "number-input-api-clear-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready(host)
        |> NumberInput.click_button_in_section(section, "Clear")

      assert NumberInput.hidden_value_at_host(session, host) == ""
    end

    feature "clear (server)  -  Clear empties value", %{session: session} do
      section = "number-input-api-clear-server-section"
      host = "number-input-api-clear-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready(host)
        |> NumberInput.click_button_in_section(section, "Clear")

      assert NumberInput.hidden_value_at_host(session, host) == ""
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

    feature "state (binding)  -  Read state shows toast", %{session: session} do
      section = "number-input-api-state-binding"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready("number-input-api-state-client")
        |> NumberInput.click_button_in_section(section, "Read state")

      NumberInput.assert_toast(session, "number-input-api-state-client")
    end

    feature "state (js)  -  Read state shows toast", %{session: session} do
      section = "number-input-api-state-js-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready("number-input-api-state-js")
        |> NumberInput.click_button_in_section(section, "Read state")

      NumberInput.assert_toast(session, "number-input-api-state-js")
    end

    feature "state server shows toast", %{session: session} do
      section = "number-input-api-state-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :api)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_root_number_input_ready("number-input-api-state-server")
        |> NumberInput.click_button_in_section(section, "Read state")

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

    feature "client  -  increment appends log row", %{session: session} do
      section = "number-input-events-client-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(NumberInput, :number_input, :events)
        |> NumberInput.prepare_live_form()
        |> NumberInput.wait_section_number_input_ready(section)

      refute NumberInput.number_input_events_client_log_has_row?(session)

      session
      |> NumberInput.click_increment_in_section(section)
      |> NumberInput.wait_for_has(
        css("#number-input-events-log-client tr[data-part='row']", count: 1),
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
end
