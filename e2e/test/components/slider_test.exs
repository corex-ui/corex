defmodule E2eWeb.SliderTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.SliderModel, as: Slider

  @moduletag :slider

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section root style updates via set-value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :anatomy)

      Enum.reduce(Slider.anatomy_single_section_ids(), session, fn section_id, sess ->
        sess
        |> Slider.wait_section_slider_ready(section_id)
        |> Slider.wait_value_text_in_section(section_id, "50")
        |> Slider.dispatch_set_value_in_section(section_id, 0.0)
        |> Slider.wait_value_text_in_section(section_id, "0")
        |> Slider.dispatch_set_value_in_section(section_id, 90.0)
        |> Slider.wait_value_text_in_section(section_id, "90")
      end)
    end

    feature "range  -  set-value keeps both thumbs", %{session: session} do
      section = "slider-anatomy-range"

      session
      |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :anatomy)
      |> Slider.wait_section_slider_ready(section)
      |> Slider.wait_value_text_in_section(section, "20 – 80")
      |> Slider.dispatch_set_value_in_section(section, [0, 80])
      |> Slider.wait_value_text_in_section(section, "0 – 80")
    end

    feature "basic  -  Home key moves thumb value toward minimum", %{session: session} do
      section = "slider-anatomy-basic"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :anatomy)
        |> Slider.wait_section_slider_ready(section)
        |> Slider.focus_thumb_in_section(section)
        |> Slider.press_key(:home, 1)

      Slider.wait_value_text_in_section(session, section, "0")
    end
  end

  describe "api" do
    feature "binding  -  Set to 0 updates root style", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :api)
      |> Slider.wait_value_text_in_section("slider-api-set-value-binding", "50")

      session
      |> Slider.click_set_to_zero_api()
      |> Slider.wait_value_text_in_section("slider-api-set-value-binding", "0")
    end

    feature "client js  -  Set to 25 updates value text", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :api)
      |> Slider.click_api_js_set_value(25)
      |> Slider.wait_value_text_in_section("slider-api-set-value-js", "25")
    end

    feature "server  -  Server 75 updates value text", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :api)
      |> Slider.click_api_server_value(75)
      |> Slider.wait_value_text_in_section("slider-api-set-value-server", "75")
    end
  end

  describe "events" do
    feature "server  -  programmatic change logs a row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :events)
        |> Slider.prepare_live_form()

      refute Slider.slider_events_server_log_has_row?(session)

      session
      |> Slider.slider_events_server_dispatch()

      assert Slider.slider_events_server_log_has_row?(session)
    end

    feature "client  -  programmatic change logs client row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :events)
        |> Slider.prepare_live_form()

      refute Slider.slider_events_client_log_has_row?(session)

      session
      |> Slider.slider_events_client_dispatch_value(
        "events-slider-on-value-change-client",
        33.0
      )
      |> Slider.wait_for_has(
        css("#slider-events-log-client tr[data-part='row']", count: 1),
        timeout: 10_000
      )

      assert Slider.slider_events_client_log_has_row?(session)
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :playground)
      |> Slider.wait_playground_slider_ready()
    end
  end

  describe "patterns" do
    feature "patterns doc page is ready", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Slider, :slider, :patterns)
      |> Slider.wait_patterns_slider_page()
    end
  end

  describe "a11y (post-interaction, scoped, theme and mode matrix)" do
    @moduletag :slider_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground slider passes axe for each theme and mode after keyboard nudge", %{
      session: session
    } do
      {path, ready_sel} = ComponentBehaviorSpec.page(:slider, :playground)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(path, css(ready_sel), theme, mode)
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> Slider.wait_playground_slider_ready()

          sess =
            Slider.check_accessibility(sess, css("#my-slider"), filter: E2eWeb.A11yDocPageFilter)

          sess
          |> Slider.focus_thumb_in_section("my-slider")
          |> Slider.press_key(:right_arrow, 1)
          |> Slider.wait(200)
          |> then(
            &Slider.check_accessibility(&1, css("#my-slider"), filter: E2eWeb.A11yDocPageFilter)
          )
      end
    end
  end
end
