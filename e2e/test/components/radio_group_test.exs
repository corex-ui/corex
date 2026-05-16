defmodule E2eWeb.RadioGroupTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.RadioGroupModel, as: RadioGroup

  feature "anatomy  -  select option B in plain section", %{session: session} do
    session
    |> RadioGroup.visit_ready("/en/radio-group/anatomy", css("#radio-group-anatomy-page"))
    |> RadioGroup.click_item_in_section("radio-group-anatomy-minimal", "b")
  end

  feature "events  -  server radio group produces log row", %{session: session} do
    session =
      session
      |> RadioGroup.visit_ready("/en/radio-group/events", css("#radio-group-events-page"))

    refute RadioGroup.radio_group_events_server_log_has_row?(session)

    session
    |> RadioGroup.click_item_in_section("radio-group-events-server", "b")

    assert RadioGroup.radio_group_events_server_log_has_row?(session)
  end

  describe "api" do
    feature "primary doc interaction", %{session: session} do
      E2eWeb.DocComponentWallaby.assert_page_behavior(session, :radio_group, :api)
    end
  end

  describe "patterns" do
    feature "primary doc interaction", %{session: session} do
      E2eWeb.DocComponentWallaby.assert_page_behavior(session, :radio_group, :patterns)
    end
  end
end
