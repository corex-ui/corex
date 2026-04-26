defmodule E2eWeb.SwitchTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.SwitchModel, as: Switch

  feature "anatomy — click control in each section", %{session: session} do
    session =
      session
      |> Switch.visit_ready("/en/switch/anatomy", css("#switch-anatomy-page"))
      |> Switch.wait(400)

    Enum.each(Switch.anatomy_section_ids(), fn section_id ->
      session
      |> Switch.click_control_in_section(section_id)
      |> Switch.wait(200)
    end)
  end

  feature "api — Off via binding", %{session: session} do
    session
    |> Switch.visit_ready("/en/switch/api", css("#switch-api-page"))
    |> Switch.wait(400)

    session
    |> Switch.click_api_off()
    |> Switch.wait(400)
  end

  feature "events — server switch produces log row", %{session: session} do
    session =
      session
      |> Switch.visit_ready("/en/switch/events", css("#switch-events-page"))
      |> Switch.wait(400)

    refute Switch.switch_events_server_log_has_row?(session)

    session
    |> Switch.click_control_in_section("switch-events-server")
    |> Switch.wait_for_has(
      css("#switch-events-log-server tr[data-part='row']"),
      timeout: 10_000
    )
  end
end
