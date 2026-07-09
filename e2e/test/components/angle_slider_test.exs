defmodule E2eWeb.AngleSliderTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.AngleSliderModel, as: AngleSlider
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :angle_slider

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section root style updates via set-value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :anatomy)

      Enum.reduce(AngleSlider.anatomy_section_ids(), session, fn section_id, sess ->
        sess
        |> AngleSlider.assert_root_style_contains(section_id, "90deg")
        |> AngleSlider.dispatch_set_value_in_section(section_id, 0.0)
        |> AngleSlider.assert_root_style_contains(section_id, "0deg")
        |> AngleSlider.dispatch_set_value_in_section(section_id, 90.0)
      end)
    end

    feature "minimal  -  Home key moves thumb value toward minimum", %{session: session} do
      section = "angle-slider-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :anatomy)
        |> AngleSlider.wait_section_angle_slider_ready(section)
        |> AngleSlider.focus_thumb_in_section(section)
        |> AngleSlider.press_key(:home, 1)

      assert String.contains?(AngleSlider.root_style_in_section(session, section), "0deg")
    end
  end

  describe "api" do
    feature "binding  -  Set to 0 updates root style", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :api)

      assert String.contains?(AngleSlider.angle_api_root_style(session), "90deg")

      session
      |> AngleSlider.click_set_to_zero_api()

      assert String.contains?(AngleSlider.angle_api_root_style(session), "0deg")
    end

    feature "client js  -  Set to 180 updates root style", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :api)
        |> AngleSlider.click_api_js_set_degrees(180)

      assert String.contains?(AngleSlider.angle_api_js_root_style(session), "180deg")
    end

    feature "server  -  Server 270 updates root style", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :api)
        |> AngleSlider.click_api_server_degrees(270)

      assert String.contains?(AngleSlider.angle_api_server_root_style(session), "270deg")
    end
  end

  describe "events" do
    feature "server  -  programmatic change logs a row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :events)
        |> AngleSlider.prepare_live_form()

      refute AngleSlider.angle_events_server_log_has_row?(session)

      session
      |> AngleSlider.angle_events_server_dispatch()

      assert AngleSlider.angle_events_server_log_has_row?(session)
    end

    feature "client  -  programmatic change logs client row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :events)
        |> AngleSlider.prepare_live_form()

      refute AngleSlider.angle_events_client_log_has_row?(session)

      session
      |> AngleSlider.angle_events_client_dispatch_value(
        "events-angle-slider-on-value-change-client",
        33.0
      )
      |> AngleSlider.wait_for_has(
        css("#angle-slider-events-log-client tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert AngleSlider.angle_events_client_log_has_row?(session)
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :playground)
      |> AngleSlider.wait_playground_angle_slider_ready()
    end
  end

  describe "patterns" do
    feature "patterns doc page is ready", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(AngleSlider, :angle_slider, :patterns)
      |> AngleSlider.wait_patterns_angle_slider_page()
    end
  end

  describe "a11y (post-interaction, scoped, theme and mode matrix)" do
    @moduletag :angle_slider_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground angle slider passes axe for each theme and mode after keyboard nudge", %{
      session: session
    } do
      {path, ready_sel} = ComponentBehaviorSpec.page(:angle_slider, :playground)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(path, css(ready_sel), theme, mode)
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> AngleSlider.wait_playground_angle_slider_ready()

          sess =
            AngleSlider.check_accessibility(sess, css("#my-angle-slider"),
              filter: E2eWeb.A11yDocPageFilter
            )

          sess
          |> AngleSlider.focus_thumb_in_section("my-angle-slider")
          |> AngleSlider.press_key(:right_arrow, 1)
          |> AngleSlider.wait(200)
          |> then(
            &AngleSlider.check_accessibility(&1, css("#my-angle-slider"),
              filter: E2eWeb.A11yDocPageFilter
            )
          )
      end
    end
  end
end
