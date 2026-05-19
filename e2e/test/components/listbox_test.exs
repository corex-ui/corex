defmodule E2eWeb.ListboxTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.ListboxModel, as: Listbox

  @moduletag :listbox

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section can select an item by click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Listbox, :listbox, :anatomy)

      _ =
        Enum.reduce(Listbox.anatomy_section_ids(), session, fn section_id, sess ->
          host_id = Listbox.listbox_host_id_for_anatomy_section(section_id)

          sess
          |> Listbox.wait_section_listbox_ready(section_id)
          |> Listbox.click_item_by_value(host_id, "bel")
          |> Listbox.wait_item_aria_selected(host_id, "bel", timeout: 5_000)
          |> then(fn s ->
            assert Listbox.item_aria_selected?(s, host_id, "bel")
            s
          end)
        end)
    end

    feature "minimal  -  keyboard moves selection from fra to bel", %{session: session} do
      section = "listbox-anatomy-minimal"
      host = Listbox.listbox_host_id_for_anatomy_section(section)

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :anatomy)
        |> Listbox.wait_section_listbox_ready(section)
        |> Listbox.click_item_by_value(host, "fra")
        |> Listbox.wait_item_aria_selected(host, "fra", timeout: 5_000)

      assert Listbox.item_aria_selected?(session, host, "fra")

      session =
        session
        |> Listbox.press_key(:down_arrow, 1)
        |> Listbox.press_enter()

      session = Listbox.wait_item_aria_selected(session, host, "bel", timeout: 5_000)

      assert Listbox.item_aria_selected?(session, host, "bel")
      refute Listbox.item_aria_selected?(session, host, "fra")
    end
  end

  describe "api" do
    feature "set value (binding)  -  Belgium selects bel", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :api)
        |> Listbox.wait_root_no_loading("#listbox-api-sv-client")

      refute Listbox.item_aria_selected?(session, "listbox-api-sv-client", "bel")

      session
      |> Listbox.click_button_in_section("listbox-api-set-value-binding", "Belgium")

      assert Listbox.item_aria_selected?(session, "listbox-api-sv-client", "bel")
    end

    feature "set value (server)  -  Belgium via push_event", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :api)
        |> Listbox.wait_root_no_loading("#listbox-api-sv-server")

      refute Listbox.item_aria_selected?(session, "listbox-api-sv-server", "bel")

      session
      |> Listbox.click_button_in_section("listbox-api-set-value-server", "Belgium")

      assert Listbox.item_aria_selected?(session, "listbox-api-sv-server", "bel")
    end

    feature "set value (js)  -  Germany via dispatch", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :api)
        |> Listbox.wait_root_no_loading("#listbox-api-sv-js")

      refute Listbox.item_aria_selected?(session, "listbox-api-sv-js", "deu")

      session
      |> Listbox.click_button_in_section("listbox-api-set-value-js", "Germany (JS.dispatch)")
      |> Listbox.wait_item_aria_selected("listbox-api-sv-js", "deu", timeout: 5_000)

      assert Listbox.item_aria_selected?(session, "listbox-api-sv-js", "deu")
    end

    feature "value (binding)  -  Read selection keeps page stable", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :api)
        |> Listbox.wait_root_no_loading("#listbox-api-val-client")

      session
      |> Listbox.click_button_in_section("listbox-api-value-binding", "Read selection")

      assert String.contains?(Wallaby.Browser.page_source(session), "listbox-api-val-client")
    end

    feature "value (server)  -  Read selection keeps page stable", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :api)
        |> Listbox.wait_root_no_loading("#listbox-api-val-server")

      _ =
        session
        |> Listbox.click_button_in_section("listbox-api-value-server", "Read selection")

      assert is_binary(Wallaby.Browser.page_source(session))
    end
  end

  describe "events" do
    feature "server  -  selection appends a log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :events)
        |> Listbox.wait_root_no_loading("#listbox-events-server")
        |> Listbox.wait_section_listbox_ready("listbox-events-server")

      refute Listbox.events_server_log_has_row?(session)

      session
      |> Listbox.click_events_server_item("listbox-events-server", "fra")
      |> Listbox.wait_for_has(css("#listbox-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )
    end

    feature "client  -  belgium appends a log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :events)
        |> Listbox.wait_root_no_loading("#listbox-events-client")

      refute Listbox.events_client_log_has_row?(session)

      _ =
        session
        |> Listbox.click_events_client_item("listbox-events-client", "bel")
        |> Listbox.wait_for_has(css("#listbox-events-log-client tr[data-part='row']", count: 1),
          timeout: 20_000
        )
    end
  end

  describe "patterns" do
    feature "stream  -  can select an item", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :patterns)
        |> Listbox.wait_root_no_loading("#stream-listbox")

      session
      |> Listbox.click_item_by_value("stream-listbox", "1")

      assert Listbox.item_aria_selected?(session, "stream-listbox", "1")
    end

    @tag :listbox_patterns_controlled
    feature "controlled  -  toggling germany updates state text", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Listbox, :listbox, :patterns)
        |> Listbox.wait_root_no_loading("#listbox-patterns-controlled-field")

      assert String.contains?(Listbox.controlled_state_text(session), "fra")
      assert String.contains?(Listbox.controlled_state_text(session), "bel")

      session
      |> Listbox.click_item_by_value("listbox-patterns-controlled-field", "deu")

      assert String.contains?(Listbox.controlled_state_text(session), "deu")
    end
  end

  describe "a11y (post-interaction, scoped, theme and mode matrix)" do
    @moduletag :listbox_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground listbox passes axe for each theme and mode after selection", %{
      session: session
    } do
      {path, ready_sel} = E2eWeb.ComponentBehaviorSpec.page(:listbox, :playground)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(path, css(ready_sel), theme, mode)
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> Listbox.wait_root_no_loading("#listbox-play")

          sess = Listbox.check_accessibility(sess, css("#listbox-play"))

          sess
          |> Listbox.click_item_by_value("listbox-play", "bel")
          |> Listbox.wait_root_no_loading("#listbox-play")
          |> Listbox.wait(200)
          |> then(&Listbox.check_accessibility(&1, css("#listbox-play")))
      end
    end
  end
end
