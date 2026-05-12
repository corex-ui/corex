defmodule E2eWeb.SwitchTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.SwitchModel, as: Switch

  feature "anatomy  -  click control in each section", %{session: session} do
    session =
      session
      |> Switch.visit_ready("/en/switch/anatomy", css("#switch-anatomy-page"))

    Enum.each(Switch.anatomy_section_ids(), fn section_id ->
      session
      |> Switch.click_control_in_section(section_id)
    end)
  end

  feature "api  -  Off via binding", %{session: session} do
    session
    |> Switch.visit_ready("/en/switch/api", css("#switch-api-page"))

    session
    |> Switch.click_api_off()
  end

  feature "events  -  server switch produces log row", %{session: session} do
    session =
      session
      |> Switch.visit_ready("/en/switch/events", css("#switch-events-page"))

    refute Switch.switch_events_server_log_has_row?(session)

    session
    |> Switch.click_control_in_section("switch-events-server")
    |> Switch.wait_for_has(
      css("#switch-events-log-server tr[data-part='row']"),
      timeout: 10_000
    )
  end
end
