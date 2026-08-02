defmodule E2eWeb.AccordionTest do
  @moduledoc """
  Accordion exemplar Wallaby suite (pilot for other Corex components).

  Behavior map (what → where). JS unit tests own hook/component contracts;
  LiveViewTest owns server event assigns (`accordion_events_live_test.exs`).
  Screen-reader CI stand-in is WAI-ARIA + axe after keyboard use (not VoiceOver/NVDA).

  ## Doc journeys (this file)

  | Page | Features |
  | --- | --- |
  | anatomy | Section toggles, indicator, slots, compound |
  | playground | dir, orientation, multiple off/on, collapsible, disable + re-enable |
  | patterns | controlled, async, dynamic add, dynamic Reset |
  | animation | js playground, instant, custom, duration control smoke |
  | api | set_value ×3, value toast ×3, focused ×3, item_state ×3 |
  | events | server/client log growth + row mentions value |
  | style | visit + open first preview accordion |

  ## Canonical keyboard / focus / ARIA

  `describe "keyboard focus and aria"` on anatomy minimal + playground horizontal.
  Do not copy that suite onto patterns/animation/style.
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.AccordionModel, as: Accordion
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :accordion

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section toggles first item", %{session: session} do
      session =
        ComponentBehaviorSpec.visit_ready(session, Accordion, :accordion, :anatomy)

      Enum.reduce(Accordion.anatomy_section_ids(), session, fn section_id, sess ->
        Accordion.assert_first_trigger_toggles(sess, section_id)
      end)
    end

    feature "minimal  -  second panel opens when its trigger is activated", %{
      session: session
    } do
      section = "accordion-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_trigger_in_section_at(section, 2)

      assert Accordion.trigger_aria_expanded_at(session, section, 2) == "true"
    end

    feature "with indicator  -  first item has indicator in the dom when expanded", %{
      session: session
    } do
      section = "accordion-anatomy-with-indicator"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_first_trigger_in_section(section)

      assert has?(
               session,
               css(~s|##{section} [data-part="item"]:first-of-type [data-part="item-indicator"]|)
             )
    end

    feature "custom slots  -  first trigger opens content", %{session: session} do
      section = "accordion-anatomy-custom-slots"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_first_trigger_in_section(section)

      assert has?(
               session,
               css(
                 ~s|##{section} [data-scope="accordion"][data-part="item-content"]|,
                 text: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
               )
             )
    end

    feature "manual slots  -  can open the second item", %{session: session} do
      section = "accordion-anatomy-manual-slots"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_trigger_in_section_at(section, 2)

      assert has?(
               session,
               css(
                 ~s|##{section} [data-scope="accordion"][data-part="item-content"]|,
                 text: "Nullam eget vestibulum ligula, at interdum tellus."
               )
             )
    end

    feature "compound  -  first item toggles", %{session: session} do
      section = "accordion-anatomy-compound"

      _ =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.assert_first_trigger_toggles(section)
    end
  end

  describe "api" do
    feature "set value (binding)  -  Open Lorem expands lorem", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-set-value-client")

      refute Accordion.lorem_trigger_expanded?(session)

      session =
        session
        |> Accordion.click_open_lorem_api()

      assert Accordion.lorem_trigger_expanded?(session)
    end

    feature "set value (js)  -  Open Lorem", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-set-value-client-js")

      session =
        session
        |> Accordion.click_in_section("accordion-api-set-value-js", "Open Lorem")

      assert Accordion.trigger_expanded?(session, "api-set-value-client-js", "lorem", "true")
    end

    feature "set value (server)  -  Open Lorem", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-set-value-server")

      session =
        session
        |> Accordion.click_in_section("accordion-api-set-value-server", "Open Lorem")

      assert Accordion.trigger_expanded?(session, "api-set-value-server", "lorem", "true")
    end

    feature "value (binding)  -  Value surfaces current state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-value-client")
        |> Accordion.prepare_live_form()

      session
      |> Accordion.click_in_section("accordion-api-value-binding", "Value")

      Accordion.assert_toast(session, "api-value-client")
    end

    feature "value (js)  -  Value dispatches a client read", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-value-client-js")
        |> Accordion.prepare_live_form()

      session
      |> Accordion.click_in_section("accordion-api-value-js", "Value")

      Accordion.assert_toast(session, "api-value-client-js")
    end

    feature "value (server)  -  Value read runs without error", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-value-server")
        |> Accordion.prepare_live_form()

      session
      |> Accordion.click_in_section("accordion-api-value-server", "Value")

      Accordion.assert_toast(session, "api-value-server")
    end

    feature "focused (binding)  -  delayed read surfaces focused value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-focused-client")
        |> Accordion.prepare_live_form()

      session
      |> Accordion.click_in_section("accordion-api-focused-binding", "Focused")

      Accordion.assert_toast(session, "api-focused-client")
    end

    feature "focused (js)  -  delayed read surfaces focused value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-focused-client-js")
        |> Accordion.prepare_live_form()

      session
      |> Accordion.click_in_section("accordion-api-focused-js", "Focused")

      Accordion.assert_toast(session, "api-focused-client-js")
    end

    feature "focused (server)  -  delayed read surfaces focused value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-focused-server")
        |> Accordion.prepare_live_form()

      session
      |> Accordion.click_in_section("accordion-api-focused-server", "Focused")

      Accordion.assert_toast(session, "api-focused-server")
    end

    feature "item state (binding)  -  donec can be set disabled", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-item-client")

      _ =
        session
        |> Accordion.click_in_section("accordion-api-item-state-binding", "donec")
        |> Accordion.wait_for_has(
          xpath("//*[@id='accordion:api-item-client:trigger:donec'][@aria-disabled]"),
          timeout: 8_000
        )
    end

    feature "item state (js)  -  donec can be set disabled", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-item-client-js")

      _ =
        session
        |> Accordion.click_in_section("accordion-api-item-state-js", "donec")
        |> Accordion.wait_for_has(
          xpath("//*[@id='accordion:api-item-client-js:trigger:donec'][@aria-disabled]"),
          timeout: 8_000
        )
    end

    feature "item state (server)  -  donec can be set disabled", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-item-server")

      _ =
        session
        |> Accordion.click_in_section("accordion-api-item-state-server", "donec")
        |> Accordion.wait_for_has(
          xpath("//*[@id='accordion:api-item-server:trigger:donec'][@aria-disabled]"),
          timeout: 8_000
        )
    end
  end

  describe "events" do
    feature "server  -  interactions append log rows", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :events)
        |> Accordion.wait_root_no_loading("#events-on-value-change-server")

      refute Accordion.events_server_log_has_row?(session)

      before = Accordion.log_row_count(session, "accordion-events-log-server")

      session =
        session
        |> Accordion.click_events_server_lorem()
        |> Accordion.wait_log_rows_grew("accordion-events-log-server", before, timeout: 10_000)

      Accordion.assert_events_log_mentions(session, "accordion-events-log-server", "lorem")

      before = Accordion.log_row_count(session, "accordion-events-log-server")

      session
      |> Accordion.click_events_server_duis()
      |> Accordion.wait_log_rows_grew("accordion-events-log-server", before, timeout: 10_000)
      |> Accordion.assert_events_log_mentions("accordion-events-log-server", "duis")
    end

    feature "client  -  duis logs a row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :events)
        |> Accordion.wait_root_no_loading("#events-on-value-change-client")

      refute Accordion.events_client_log_has_row?(session)

      before = Accordion.log_row_count(session, "accordion-events-log-client")

      _ =
        session
        |> Accordion.click_events_client_duis()
        |> Accordion.wait_log_rows_grew("accordion-events-log-client", before, timeout: 20_000)
        |> Accordion.assert_events_log_mentions("accordion-events-log-client", "duis")
    end
  end

  describe "playground" do
    feature "dir toggles the accordion direction attribute", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      assert Accordion.my_accordion_attribute(session, "data-dir") == "ltr"

      session =
        session
        |> click(css(~S|#dir [data-scope="toggle-group"][data-part="item"][data-value="rtl"]|))
        |> Accordion.wait_root_no_loading("#my-accordion")

      assert Accordion.my_accordion_attribute(session, "data-dir") == "rtl"
    end

    feature "orientation  -  horizontal sets data-orientation on the inner root", %{
      session: session
    } do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      _ =
        session
        |> click(
          xpath(
            "//*[@id='orientation']//*[contains(@aria-label, 'Horizontal') or contains(.,'Horizontal')][1]"
          )
        )
        |> Accordion.wait_root_no_loading("#my-accordion")

      assert Accordion.my_accordion_inner_orientation(session) == "horizontal"
    end

    feature "multiple off  -  at most one section stays expanded", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      session
      |> Accordion.click_playground_multiple()
      |> Accordion.wait_root_no_loading("#my-accordion")

      _ =
        session
        |> Accordion.click_first_trigger_in_section("my-accordion")
        |> Accordion.click_trigger_in_section_at("my-accordion", 2)

      assert Accordion.first_trigger_aria_expanded(session, "my-accordion") == "false"
      assert Accordion.trigger_aria_expanded_at(session, "my-accordion", 2) == "true"
    end

    feature "multiple on  -  more than one section can stay expanded", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.click_first_trigger_in_section("my-accordion")
        |> Accordion.click_trigger_in_section_at("my-accordion", 2)
        |> Accordion.click_first_trigger_in_section("my-accordion")
        |> Accordion.click_trigger_in_section_at("my-accordion", 2)

      assert Accordion.first_trigger_aria_expanded(session, "my-accordion") == "true"
      assert Accordion.trigger_aria_expanded_at(session, "my-accordion", 2) == "true"
    end

    feature "collapsible off  -  last open item stays expanded", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.click_playground_multiple()
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.click_playground_collapsible()
        |> Accordion.wait_root_no_loading("#my-accordion")

      assert Accordion.trigger_expanded?(session, "my-accordion", "lorem", "true")

      session =
        session
        |> Accordion.click_first_trigger_in_section("my-accordion")

      assert Accordion.trigger_expanded?(session, "my-accordion", "lorem", "true")
    end

    feature "playground  -  disabled lorem is not activatable", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      _ =
        session
        |> Accordion.set_playground_disabled_item("lorem")
        |> Accordion.wait_root_no_loading("#my-accordion")

      assert Accordion.trigger_aria_disabled?(session, "my-accordion", "lorem")
    end

    feature "playground  -  re-enabling lorem clears trigger disabled", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.set_playground_disabled_item("lorem")
        |> Accordion.wait_root_no_loading("#my-accordion")

      assert Accordion.trigger_aria_disabled?(session, "my-accordion", "lorem")

      session =
        session
        |> Accordion.clear_playground_disabled_items()
        |> Accordion.wait_root_no_loading("#my-accordion")

      refute Accordion.trigger_aria_disabled?(session, "my-accordion", "lorem")
      refute Accordion.item_data_disabled?(session, "my-accordion", "lorem")
    end
  end

  describe "patterns" do
    @tag :accordion_patterns_controlled
    feature "controlled  -  clicking duis updates which item is open", %{session: session} do
      section = "accordion-patterns-controlled"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
        |> Accordion.wait_root_no_loading("#patterns-controlled")

      assert Accordion.trigger_expanded?(session, "patterns-controlled", "lorem", "true")
      assert Accordion.trigger_expanded?(session, "patterns-controlled", "duis", "false")

      session =
        session
        |> Accordion.click_trigger_in_section_at(section, 2)

      assert Accordion.trigger_expanded?(session, "patterns-controlled", "duis", "true")
      assert Accordion.trigger_expanded?(session, "patterns-controlled", "lorem", "false")
    end

    feature "async  -  accordion renders after data loads", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
      |> Accordion.wait_root_no_loading("#patterns-async", timeout: 20_000)

      assert Accordion.trigger_expanded?(session, "patterns-async", "duis", "true")
    end

    feature "dynamic  -  added item can expand", %{session: session} do
      section = "accordion-patterns-dynamic"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
        |> Accordion.wait_root_no_loading("#patterns-dynamic")
        |> click(css(~s|##{section} button[phx-click="add_item"]|))

      session =
        session
        |> Accordion.wait_root_no_loading("#patterns-dynamic")
        |> Accordion.click_trigger_in_section_at(section, 4)

      assert Accordion.trigger_expanded?(session, "patterns-dynamic", "4", "true")
    end

    feature "dynamic  -  Reset restores the initial item set", %{session: session} do
      section = "accordion-patterns-dynamic"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
        |> Accordion.wait_root_no_loading("#patterns-dynamic")
        |> Accordion.click_in_section(section, "Reset")
        |> Accordion.wait_root_no_loading("#patterns-dynamic")

      assert Accordion.trigger_count(session, section) == 3

      session =
        session
        |> click(css(~s|##{section} button[phx-click="add_item"]|))
        |> Accordion.wait_root_no_loading("#patterns-dynamic")

      assert Accordion.trigger_count(session, section) == 4

      session =
        session
        |> Accordion.click_in_section(section, "Reset")
        |> assert_has(
          css(~s|##{section} [id="accordion:patterns-dynamic:trigger:4"]|,
            count: 0,
            visible: :any
          )
        )
        |> Accordion.wait_root_no_loading("#patterns-dynamic")

      assert Accordion.trigger_count(session, section) == 3
    end
  end

  describe "animation" do
    feature "instant  -  first item can expand", %{session: session} do
      section = "accordion-animation-instant"

      _ =
        Accordion.assert_first_trigger_toggles(
          session
          |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :animation),
          section
        )
    end

    feature "playground  -  accordion with js animation can expand", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :animation)
        |> Accordion.wait_root_no_loading("#accordion-animation-playground-accordion",
          timeout: 20_000
        )

      _ = Accordion.assert_first_trigger_toggles(session, "accordion-animation-playground")
    end

    feature "custom  -  first item can expand", %{session: session} do
      section = "accordion-animation-custom"

      _ =
        Accordion.assert_first_trigger_toggles(
          session
          |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :animation),
          section
        )
    end

    feature "playground  -  duration control change still expands", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :animation)
        |> Accordion.wait_root_no_loading("#accordion-animation-playground-accordion",
          timeout: 20_000
        )
        |> click(css("#accordion-animation-duration [data-part='increment-trigger']"))
        |> Accordion.wait_root_no_loading("#accordion-animation-playground-accordion")

      _ = Accordion.assert_first_trigger_toggles(session, "accordion-animation-playground")
    end
  end

  describe "style" do
    feature "preview  -  first accordion toggles", %{session: session} do
      _ =
        Accordion.assert_first_trigger_toggles(
          session
          |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :style),
          "accordion-styling-preview"
        )
    end
  end

  describe "keyboard focus and aria" do
    feature "space and enter toggle the focused anatomy trigger", %{session: session} do
      section = "accordion-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.focus_trigger_in_section(section, "lorem")

      before = Accordion.trigger_aria_expanded_at(session, section, 1)

      session = Accordion.press_key_on_active(session, :space)
      flipped = if before == "true", do: "false", else: "true"
      assert Accordion.trigger_aria_expanded_at(session, section, 1) == flipped

      session = Accordion.press_key_on_active(session, :enter)
      assert Accordion.trigger_aria_expanded_at(session, section, 1) == before
    end

    feature "arrows move focus vertically on anatomy minimal", %{session: session} do
      section = "accordion-anatomy-minimal"

      _ =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.focus_trigger_in_section(section, "lorem")
        |> Accordion.press_key_on_active(:down_arrow)
        |> Accordion.assert_active_trigger_in_section(section, "duis")
        |> Accordion.press_key_on_active(:up_arrow)
        |> Accordion.assert_active_trigger_in_section(section, "lorem")
    end

    feature "home and end focus first and last enabled triggers", %{session: session} do
      section = "accordion-anatomy-minimal"

      _ =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.focus_trigger_in_section(section, "duis")
        |> Accordion.press_key_on_active(:home)
        |> Accordion.assert_active_trigger_in_section(section, "lorem")
        |> Accordion.press_key_on_active(:end)
        |> Accordion.assert_active_trigger_in_section(section, "donec")
    end

    feature "horizontal playground arrows move focus", %{session: session} do
      _ =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> click(
          xpath(
            "//*[@id='orientation']//*[contains(@aria-label, 'Horizontal') or contains(.,'Horizontal')][1]"
          )
        )
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.focus_trigger("my-accordion", "lorem")
        |> Accordion.press_key_on_active(:right_arrow)
        |> Accordion.assert_active_trigger("my-accordion", "duis")
        |> Accordion.press_key_on_active(:left_arrow)
        |> Accordion.assert_active_trigger("my-accordion", "lorem")
    end

    feature "arrows skip disabled playground triggers", %{session: session} do
      _ =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.set_playground_disabled_item("duis")
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.focus_trigger("my-accordion", "lorem")
        |> Accordion.press_key_on_active(:down_arrow)
        |> Accordion.assert_active_trigger("my-accordion", "donec")
    end

    feature "click focuses the anatomy trigger", %{session: session} do
      section = "accordion-anatomy-minimal"

      _ =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_trigger_in_section_at(section, 2)
        |> Accordion.assert_active_trigger_in_section(section, "duis")
    end

    feature "aria-controls associates trigger with content", %{session: session} do
      section = "accordion-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.assert_aria_controls_in_section(section, "lorem")
        |> Accordion.click_first_trigger_in_section(section)

      assert Accordion.trigger_aria_expanded_at(session, section, 1) == "true"
      Accordion.assert_aria_controls_in_section(session, section, "lorem")
    end

    feature "scoped axe after keyboard open on anatomy", %{session: session} do
      section = "accordion-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.focus_trigger_in_section(section, "lorem")
        |> Accordion.press_key_on_active(:space)
        |> Accordion.wait(400)

      Accordion.check_accessibility(session, css("##{section}"), filter: E2eWeb.A11yDocPageFilter)
    end
  end

  describe "a11y (post-interaction, scoped)" do
    @moduletag :accordion_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground  -  axe matrix theme and mode with interaction states", %{
      session: session
    } do
      {play_path, ready_sel} = E2eWeb.ComponentBehaviorSpec.page(:accordion, :playground)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(
              play_path,
              css(ready_sel),
              theme,
              mode
            )
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> Accordion.wait_root_no_loading("#my-accordion")

          sess =
            Accordion.check_accessibility(sess, css("#my-accordion"),
              filter: E2eWeb.A11yDocPageFilter
            )

          sess =
            sess
            |> Accordion.click_first_trigger_in_section("my-accordion")
            |> Accordion.wait_root_no_loading("#my-accordion")
            |> Accordion.wait(400)

          sess =
            Accordion.check_accessibility(sess, css("#my-accordion"),
              filter: E2eWeb.A11yDocPageFilter
            )

          sess =
            sess
            |> Accordion.click_trigger_in_section_at("my-accordion", 2)
            |> Accordion.wait_root_no_loading("#my-accordion")
            |> Accordion.wait(400)

          Accordion.check_accessibility(sess, css("#my-accordion"),
            filter: E2eWeb.A11yDocPageFilter
          )
      end
    end

    @tag :accordion_patterns_controlled
    feature "patterns controlled  -  axe matrix theme and mode", %{session: session} do
      {path, ready_sel} = E2eWeb.ComponentBehaviorSpec.page(:accordion, :patterns)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(path, css(ready_sel), theme, mode)
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> Accordion.wait_root_no_loading("#patterns-controlled")

          sess =
            Accordion.check_accessibility(sess, css("#accordion-patterns-controlled"))

          sess =
            sess
            |> Accordion.click_trigger_in_section_at("accordion-patterns-controlled", 2)
            |> Accordion.wait_root_no_loading("#patterns-controlled")
            |> Accordion.wait(400)

          Accordion.check_accessibility(sess, css("#accordion-patterns-controlled"))
      end
    end
  end
end
