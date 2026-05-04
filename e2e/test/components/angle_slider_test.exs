defmodule E2eWeb.AngleSliderTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.AngleSliderModel, as: AngleSlider

  setup do
    Localize.put_locale(:en)
    :ok
  end

  feature "anatomy — each section root style updates via set-value", %{session: session} do
    session =
      session
      |> E2eWeb.ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :anatomy)

    Enum.reduce(AngleSlider.anatomy_section_ids(), session, fn section_id, sess ->
      sess
      |> AngleSlider.assert_root_style_contains(section_id, "90deg")
      |> AngleSlider.dispatch_set_value_in_section(section_id, 0.0)
      |> AngleSlider.assert_root_style_contains(section_id, "0deg")
      |> AngleSlider.dispatch_set_value_in_section(section_id, 90.0)
    end)
  end

  feature "api — Set to 0° updates root style", %{session: session} do
    session
    |> E2eWeb.ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :api)

    assert String.contains?(AngleSlider.angle_api_root_style(session), "90deg")

    session
    |> AngleSlider.click_set_to_zero_api()

    assert String.contains?(AngleSlider.angle_api_root_style(session), "0deg")
  end

  feature "events — server slider logs a row", %{session: session} do
    session =
      session
      |> E2eWeb.ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :events)

    refute AngleSlider.angle_events_server_log_has_row?(session)

    session
    |> AngleSlider.angle_events_server_dispatch()

    assert AngleSlider.angle_events_server_log_has_row?(session)
  end
end
