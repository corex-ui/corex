defmodule E2eWeb.CheckboxTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.CheckboxModel, as: Checkbox

  setup do
    Localize.put_locale(:en)
    :ok
  end

  feature "anatomy — click control in each section", %{session: session} do
    session =
      session
      |> E2eWeb.ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :anatomy)
      |> Checkbox.wait(400)

    Enum.each(Checkbox.anatomy_section_ids(), fn section_id ->
      session
      |> Checkbox.click_control_in_section(section_id)
      |> Checkbox.wait(200)
    end)
  end

  feature "api — Set unchecked via binding", %{session: session} do
    session
    |> E2eWeb.ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :api)
    |> Checkbox.wait(400)

    session
    |> Checkbox.click_api_set_unchecked()
    |> Checkbox.wait(400)
  end

  feature "events — server checkbox produces log row", %{session: session} do
    session =
      session
      |> E2eWeb.ComponentBehaviorSpec.visit_ready(Checkbox, :checkbox, :events)
      |> Checkbox.wait(400)

    refute Checkbox.checkbox_events_server_log_has_row?(session)

    session
    |> Checkbox.click_control_in_section("checkbox-events-server")
    |> Checkbox.wait_for_has(
      css("#checkbox-events-log-server tr[data-part='row']"),
      timeout: 10_000
    )
  end
end
