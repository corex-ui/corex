defmodule E2eWeb.AccordionTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

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

    feature "minimal — second panel opens when its trigger is activated", %{
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

    feature "with indicator — first item has indicator in the dom when expanded", %{
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

    feature "custom slots — first trigger opens content", %{session: session} do
      section = "accordion-anatomy-custom-slots"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_first_trigger_in_section(section)

      assert Accordion.content_visible?(
               session,
               "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
             )
    end

    feature "manual slots — can open the second item", %{session: session} do
      section = "accordion-anatomy-manual-slots"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_trigger_in_section_at(section, 2)

      assert Accordion.content_visible?(
               session,
               "Nullam eget vestibulum ligula, at interdum tellus."
             )
    end

    @tag :skip
    feature "compound — first item toggles", %{session: session} do
      section = "accordion-anatomy-compound"
      _ = Accordion.assert_first_trigger_toggles(session, section)
    end

    feature "keyboard — space toggles the focused trigger (minimal)", %{session: session} do
      section = "accordion-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_first_trigger_in_section(section)

      assert Accordion.first_trigger_aria_expanded(session, section) == "true"

      session
      |> Accordion.press_space()

      assert Accordion.first_trigger_aria_expanded(session, section) == "false"
    end

    feature "keyboard — arrow and enter on the trigger list (minimal)", %{session: session} do
      section = "accordion-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :anatomy)
        |> Accordion.wait_section_accordion_ready(section)
        |> Accordion.click_first_trigger_in_section(section)

      session
      |> Accordion.press_key(:down_arrow, 1)
      |> Accordion.press_enter()

      assert Accordion.first_trigger_aria_expanded(session, section) in ["true", "false"]
      assert Accordion.trigger_aria_expanded_at(session, section, 2) in ["true", "false"]
    end
  end

  describe "api" do
    feature "set value (binding) — Open Lorem expands lorem", %{session: session} do
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

    feature "set value (js) — Open Lorem", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-set-value-client-js")

      session =
        session
        |> Accordion.click_in_section("accordion-api-set-value-js", "Open Lorem")

      assert Accordion.trigger_expanded?(session, "api-set-value-client-js", "lorem", "true")
    end

    feature "set value (server) — Open Lorem", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-set-value-server")

      session =
        session
        |> Accordion.click_in_section("accordion-api-set-value-server", "Open Lorem")

      assert Accordion.trigger_expanded?(session, "api-set-value-server", "lorem", "true")
    end

    feature "value (binding) — Value surfaces current state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-value-client")

      session
      |> Accordion.click_in_section("accordion-api-value-binding", "Value")

      assert String.contains?(
               Wallaby.Browser.page_source(session),
               "api-value-client"
             )
    end

    feature "value (js) — Value dispatches a client read", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-value-client-js")

      session =
        session
        |> Accordion.click_in_section("accordion-api-value-js", "Value")

      assert is_binary(Wallaby.Browser.page_source(session))
    end

    feature "value (server) — Value read runs without error", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-value-server")

      _ =
        session
        |> Accordion.click_in_section("accordion-api-value-server", "Value")

      assert is_binary(Wallaby.Browser.page_source(session))
    end

    @tag :skip
    feature "focused (binding) — delayed read focuses a trigger", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-focused-client")

      session
      |> Accordion.click_in_section("accordion-api-focused-binding", "Focused")

      Accordion.assert_active_element_inside_id(session, "api-focused-client")
    end

    @tag :skip
    feature "focused (js) — delayed read focuses a trigger", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-focused-client-js")

      session
      |> Accordion.click_in_section("accordion-api-focused-js", "Focused")

      Accordion.assert_active_element_inside_id(session, "api-focused-client-js")
    end

    @tag :skip
    feature "focused (server) — delayed read focuses a trigger", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-focused-server")

      session
      |> Accordion.click_in_section("accordion-api-focused-server", "Focused")

      Accordion.assert_active_element_inside_id(session, "api-focused-server")
    end

    @tag :skip
    feature "item state (binding) — donec can be set disabled", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-item-client")

      session =
        session
        |> Accordion.click_in_section("accordion-api-item-state-binding", "donec")

      assert Accordion.item_data_disabled?(session, "api-item-client", "donec") or
               Accordion.trigger_aria_disabled?(session, "api-item-client", "donec")
    end

    @tag :skip
    feature "item state (js) — donec can be set disabled", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-item-client-js")

      session =
        session
        |> Accordion.click_in_section("accordion-api-item-state-js", "donec")

      assert Accordion.trigger_aria_disabled?(session, "api-item-client-js", "donec")
    end

    @tag :skip
    feature "item state (server) — donec can be set disabled", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :api)
        |> Accordion.wait_root_no_loading("#api-item-server")

      session =
        session
        |> Accordion.click_in_section("accordion-api-item-state-server", "donec")

      assert Accordion.item_data_disabled?(session, "api-item-server", "donec") or
               Accordion.trigger_aria_disabled?(session, "api-item-server", "donec")
    end
  end

  describe "events" do
    feature "server — interactions append log rows", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :events)
        |> Accordion.wait_root_no_loading("#events-on-value-change-server")

      refute Accordion.events_server_log_has_row?(session)

      session =
        session
        |> Accordion.click_events_server_lorem()
        |> Accordion.wait_for_has(
          css("#accordion-events-log-server tr[data-part='row']", count: 1),
          timeout: 10_000
        )

      session
      |> Accordion.click_events_server_duis()
      |> Accordion.wait_for_has(
        css("#accordion-events-log-server tr[data-part='row']", count: 2),
        timeout: 10_000
      )
    end

    feature "client — duis logs a row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :events)
        |> Accordion.wait_root_no_loading("#events-on-value-change-client")

      refute Accordion.events_client_log_has_row?(session)

      _ =
        session
        |> Accordion.click_events_client_duis()
        |> Accordion.wait_for_has(
          css("#accordion-events-log-client tr[data-part='row']", count: 1),
          timeout: 20_000
        )
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

    feature "orientation — horizontal sets data-orientation on the inner root", %{
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

    feature "multiple off — at most one section stays expanded", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      session
      |> click(css("#multiple [data-part='control']"))
      |> Accordion.wait_root_no_loading("#my-accordion")

      _ =
        session
        |> Accordion.click_first_trigger_in_section("my-accordion")
        |> Accordion.click_trigger_in_section_at("my-accordion", 2)

      assert Accordion.first_trigger_aria_expanded(session, "my-accordion") == "false"
      assert Accordion.trigger_aria_expanded_at(session, "my-accordion", 2) == "true"
    end

    feature "playground — disabled lorem is not activatable", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      _ =
        session
        |> click(css("#playground-disabled-items [data-part='trigger']"))
        |> click(css("#playground-disabled-items [data-part='item'][data-value='lorem']"))
        |> Accordion.click_outside()
        |> Accordion.wait_root_no_loading("#my-accordion")

      assert Accordion.trigger_aria_disabled?(session, "my-accordion", "lorem")
    end

    feature "size — SM adds accordion--sm on the host", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      session =
        session
        |> click(css("#accordion-size [data-part='trigger']"))
        |> click(
          css(~S|#accordion-size [data-scope="select"][data-part="item"][data-value="sm"]|)
        )
        |> Accordion.wait_root_no_loading("#my-accordion")

      el = find(session, css("#my-accordion"))
      classes = Wallaby.Element.attr(el, "class")
      assert String.contains?(classes, "accordion--sm")
    end

    feature "color — accent adds accordion--accent on the host", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      session =
        session
        |> click(css("#accordion-color [data-part='trigger']"))
        |> click(css("#accordion-color [data-part='item'][data-value='accent']"))
        |> Accordion.wait_root_no_loading("#my-accordion")

      el = find(session, css("#my-accordion"))
      classes = Wallaby.Element.attr(el, "class")
      assert String.contains?(classes, "accordion--accent")
    end
  end

  describe "patterns" do
    feature "open single — switching items keeps a single open selection", %{
      session: session
    } do
      section = "accordion-patterns-open-single"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
        |> Accordion.wait_root_no_loading("#patterns-open-single")

      assert Accordion.trigger_expanded?(session, "patterns-open-single", "lorem", "true")

      _ =
        session
        |> Accordion.click_trigger_in_section_at(section, 2)

      assert Accordion.trigger_expanded?(session, "patterns-open-single", "duis", "true")
      refute Accordion.trigger_expanded?(session, "patterns-open-single", "lorem", "true")
    end

    feature "open multiple — two items are expanded initially", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
        |> Accordion.wait_root_no_loading("#patterns-open-multiple")

      assert Accordion.trigger_expanded?(session, "patterns-open-multiple", "lorem", "true")
      assert Accordion.trigger_expanded?(session, "patterns-open-multiple", "donec", "true")
    end

    @tag :accordion_patterns_controlled
    feature "controlled — clicking duis updates which item is open", %{session: session} do
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

    feature "async — accordion renders after data loads", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
      |> Accordion.wait_root_no_loading("#patterns-async", timeout: 20_000)

      assert Accordion.trigger_expanded?(session, "patterns-async", "duis", "true")
    end
  end

  describe "animation" do
    feature "instant — first item can expand", %{session: session} do
      section = "accordion-animation-instant"

      _ =
        Accordion.assert_first_trigger_toggles(
          session
          |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :animation),
          section
        )
    end

    feature "playground — accordion with js animation can expand", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :animation)
        |> Accordion.wait_root_no_loading("#accordion-animation-playground-accordion",
          timeout: 20_000
        )

      _ = Accordion.assert_first_trigger_toggles(session, "accordion-animation-playground")
    end
  end

  describe "a11y (post-interaction, scoped)" do
    @moduletag :accordion_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground — #my-accordion passes axe at baseline and after first expand", %{
      session: session
    } do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :playground)
        |> Accordion.wait_root_no_loading("#my-accordion")

      session =
        Accordion.check_accessibility(session, css("#my-accordion"),
          filter: E2eWeb.A11yDocPageFilter
        )

      session =
        session
        |> Accordion.click_first_trigger_in_section("my-accordion")
        |> Accordion.wait_root_no_loading("#my-accordion")
        |> Accordion.wait(400)

      Accordion.check_accessibility(session, css("#my-accordion"),
        filter: E2eWeb.A11yDocPageFilter
      )
    end

    @tag :accordion_patterns_controlled
    feature "patterns — #accordion-patterns-controlled passes axe before and after open change",
            %{
              session: session
            } do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Accordion, :accordion, :patterns)
        |> Accordion.wait_root_no_loading("#patterns-controlled")

      session = Accordion.check_accessibility(session, css("#accordion-patterns-controlled"))

      session =
        session
        |> Accordion.click_trigger_in_section_at("accordion-patterns-controlled", 2)
        |> Accordion.wait_root_no_loading("#patterns-controlled")
        |> Accordion.wait(400)

      Accordion.check_accessibility(session, css("#accordion-patterns-controlled"))
    end
  end
end
