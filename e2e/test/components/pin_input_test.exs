defmodule E2eWeb.PinInputTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.PinInputModel, as: PinInput

  @moduletag :pin_input

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal section accepts pin digits", %{session: session} do
      section = "pin-input-anatomy-minimal"
      host = PinInput.pin_host_id_for_section(section)

      session
      |> ComponentBehaviorSpec.visit_ready(PinInput, :pin_input, :anatomy)
      |> PinInput.wait_section_pin_input_ready(section)
      |> PinInput.fill_pin_in_section(section, "1234", host)
      |> PinInput.wait_pin_complete_in_section(host, "1234", timeout: 8_000)
    end
  end

  describe "api" do
    feature "set value (binding)  -  Fill sets all cells", %{session: session} do
      section = "pin-input-api-set-value-binding"
      host = "pin-api-set-client"

      session
      |> ComponentBehaviorSpec.visit_ready(PinInput, :pin_input, :api)
      |> PinInput.wait_section_pin_input_ready(section)
      |> PinInput.click_button_in_section(section, "Fill")
      |> PinInput.wait_pin_complete_in_section(host, "1234", timeout: 8_000)
    end

    feature "set value (server)  -  Fill from server sets cells", %{session: session} do
      section = "pin-input-api-set-value-server"
      host = "pin-api-set-server"

      session
      |> ComponentBehaviorSpec.visit_ready(PinInput, :pin_input, :api)
      |> PinInput.prepare_live_form()
      |> PinInput.wait_section_pin_input_ready(section)
      |> PinInput.click_button_in_section(section, "Fill from server")
      |> PinInput.wait_pin_complete_in_section(host, "1234", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  typing appends log row", %{session: session} do
      section = "pin-input-events-server-section"
      host = "pin-input-events-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(PinInput, :pin_input, :events)
        |> PinInput.prepare_live_form()
        |> PinInput.wait_section_pin_input_ready(section)

      before = PinInput.log_row_count(session, "pin-input-events-log-server")

      session
      |> PinInput.fill_pin_in_section(section, "1234", host)
      |> PinInput.wait_pin_complete_in_section(host, "1234", timeout: 8_000)
      |> PinInput.wait_log_rows_grew("pin-input-events-log-server", before, timeout: 10_000)
    end
  end
end
