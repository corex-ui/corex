defmodule E2eWeb.ComboboxTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query
  alias E2eWeb.ComboboxModel, as: Combobox
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :combobox

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section can select Belgium by click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Combobox, :combobox, :anatomy)

      _ =
        Enum.reduce(Combobox.anatomy_section_ids(), session, fn section_id, sess ->
          sess
          |> Combobox.wait_section_combobox_ready(section_id)
          |> Combobox.open_combobox_in_anatomy_section(section_id)
          |> Combobox.click_item_in_anatomy_section(section_id, "bel")
          |> Combobox.wait_hidden_value_in_anatomy_section(section_id, "bel", timeout: 8_000)
        end)
    end
  end

  describe "api" do
    feature "set value (binding)  -  Belgium selects bel", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :api)
        |> Combobox.wait_root_combobox_ready("combobox-api-sv-client")

      refute Combobox.hidden_input_value_by_host_id(session, "combobox-api-sv-client") == "bel"

      session
      |> Combobox.click_button_in_section("combobox-api-set-value-binding", "Belgium")

      Combobox.wait_hidden_value_by_host_id(session, "combobox-api-sv-client", "bel",
        timeout: 8_000
      )
    end

    feature "set value (server)  -  Belgium via LiveView", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :api)
        |> Combobox.wait_root_combobox_ready("combobox-api-sv-server")

      refute Combobox.hidden_input_value_by_host_id(session, "combobox-api-sv-server") == "bel"

      session
      |> Combobox.click_button_in_section("combobox-api-set-value-server", "Belgium")

      Combobox.wait_hidden_value_by_host_id(session, "combobox-api-sv-server", "bel",
        timeout: 8_000
      )
    end

    feature "set value (js)  -  Germany via dispatch", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :api)
        |> Combobox.wait_root_combobox_ready("combobox-api-sv-js")

      refute Combobox.hidden_input_value_by_host_id(session, "combobox-api-sv-js") == "deu"

      session
      |> Combobox.click_button_in_section("combobox-api-set-value-js", "Germany")

      Combobox.wait_hidden_value_by_host_id(session, "combobox-api-sv-js", "deu", timeout: 8_000)
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :playground)
      |> Combobox.wait_playground_combobox_ready()
    end

    feature "stays anchored after LiveView patch while open", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :playground)
      |> Combobox.prepare_live_form()
      |> Combobox.wait_playground_combobox_ready()
      |> Combobox.disable_playground_close_on_select()
      |> Combobox.open_combobox_by_host_id("combobox-playground", timeout: 8_000)
      |> Combobox.click_item_by_host_id("combobox-playground", "bel", timeout: 8_000)
      |> Combobox.wait_hidden_value_by_host_id("combobox-playground", "bel", timeout: 8_000)
      |> Combobox.wait_playground_patch_rev(1, timeout: 8_000)
      |> Combobox.wait_combobox_content_open("combobox-playground", timeout: 8_000)
      |> Combobox.assert_positioner_anchored("combobox-playground")
    end

    feature "disabling an item keeps custom item slots", %{session: session} do
      host = "combobox-playground"

      session
      |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :playground)
      |> Combobox.prepare_live_form()
      |> Combobox.wait_playground_combobox_ready()
      |> Combobox.disable_playground_close_on_select()
      |> Combobox.open_combobox_by_host_id(host, timeout: 8_000)
      |> Combobox.assert_playground_item_keeps_custom_slot(host, "fra")
      |> Combobox.disable_playground_item("bel")
      |> Combobox.wait_root_combobox_ready(host)
      |> Combobox.open_combobox_by_host_id(host, timeout: 8_000)
      |> Combobox.assert_playground_item_keeps_custom_slot(host, "fra")
      |> Combobox.assert_playground_item_keeps_custom_slot(host, "deu")
      |> Combobox.click_item_by_host_id(host, "deu", timeout: 8_000)
      |> Combobox.wait_hidden_value_by_host_id(host, "deu", timeout: 8_000)
      |> Combobox.wait_combobox_content_open(host, timeout: 8_000)
      |> Combobox.assert_playground_item_keeps_custom_slot(host, "fra")
      |> Combobox.assert_playground_item_keeps_custom_slot(host, "deu")
      |> Combobox.assert_playground_item_keeps_custom_slot(host, "nld")
    end
  end

  describe "patterns" do
    feature "server filter combobox is interactive", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :patterns)
      |> Combobox.wait_patterns_page()
      |> Combobox.wait_root_combobox_ready("combobox-patterns-server-filter-field")
    end

    feature "server filter  -  open shows content", %{session: session} do
      host = "combobox-patterns-server-filter-field"

      session
      |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :patterns)
      |> Combobox.wait_patterns_page()
      |> Combobox.wait_root_combobox_ready(host)
      |> Combobox.open_combobox_by_host_id(host, timeout: 8_000)
      |> Combobox.wait_combobox_content_open(host, timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  select appends log row with value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :events)
        |> Combobox.wait_root_combobox_ready("combobox-events-server-field")

      refute Combobox.events_server_log_has_row?(session)

      before = Combobox.log_row_count(session, "combobox-events-log-server")

      session =
        session
        |> Combobox.open_combobox_by_host_id("combobox-events-server-field", timeout: 8_000)
        |> Combobox.click_item_by_host_id("combobox-events-server-field", "bel", timeout: 8_000)
        |> Combobox.wait_log_rows_grew("combobox-events-log-server", before, timeout: 10_000)

      Combobox.assert_events_log_mentions(session, "combobox-events-log-server", "bel")
    end

    feature "client  -  select appends client log row with value", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :events)
        |> Combobox.wait_root_combobox_ready("combobox-events-client-field")

      refute Combobox.events_client_log_has_row?(session)

      before = Combobox.log_row_count(session, "combobox-events-log-client")

      session
      |> Combobox.open_combobox_by_host_id("combobox-events-client-field", timeout: 8_000)
      |> Combobox.click_item_by_host_id("combobox-events-client-field", "fra", timeout: 8_000)
      |> Combobox.wait_log_rows_grew("combobox-events-log-client", before, timeout: 10_000)
      |> Combobox.assert_events_log_mentions("combobox-events-log-client", "fra")
    end
  end

  describe "keyboard focus and aria" do
    feature "space opens the combobox trigger on anatomy minimal", %{session: session} do
      section = "combobox-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :anatomy)
        |> Combobox.wait_section_combobox_ready(section)
        |> Combobox.focus_trigger_in_section(section)

      refute Combobox.content_open_in_section?(session, section)

      session = Combobox.press_key_on_active(session, :space)

      assert Combobox.content_open_in_section?(session, section)
    end

    feature "enter opens the combobox trigger on anatomy minimal", %{session: session} do
      section = "combobox-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :anatomy)
        |> Combobox.wait_section_combobox_ready(section)
        |> Combobox.focus_trigger_in_section(section)

      session = Combobox.press_key_on_active(session, :enter)

      assert Combobox.content_open_in_section?(session, section)
    end

    feature "arrows move highlight through items on anatomy minimal", %{session: session} do
      section = "combobox-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :anatomy)
        |> Combobox.wait_section_combobox_ready(section)
        |> Combobox.focus_trigger_in_section(section)
        |> Combobox.press_key_on_active(:space)

      Combobox.wait_for_has(
        session,
        css(
          ~s|section##{section} [data-scope="combobox"][data-part="content"][data-state="open"]|,
          visible: :any
        ),
        timeout: 5_000
      )

      session
      |> Combobox.press_key_on_active(:down_arrow)
      |> Combobox.assert_highlighted_item_in_section(section, "fra")
      |> Combobox.press_key_on_active(:down_arrow)
      |> Combobox.assert_highlighted_item_in_section(section, "bel")
    end

    feature "escape closes open combobox on anatomy minimal", %{session: session} do
      section = "combobox-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :anatomy)
        |> Combobox.wait_section_combobox_ready(section)
        |> Combobox.focus_trigger_in_section(section)
        |> Combobox.press_key_on_active(:space)

      assert Combobox.content_open_in_section?(session, section)

      session = Combobox.press_key_on_active(session, :escape)

      refute Combobox.content_open_in_section?(session, section)
    end
  end

  describe "a11y (post-interaction, scoped, theme and mode matrix)" do
    @moduletag :combobox_a11y_interactive
    @moduletag :slow
    @describetag :e2e

    feature "playground combobox passes axe for each theme and mode after selection", %{
      session: session
    } do
      {path, ready_sel} = ComponentBehaviorSpec.page(:combobox, :playground)

      for {theme, mode} <- E2eWeb.A11yThemeMode.combos(), reduce: session do
        sess ->
          sess =
            sess
            |> E2eWeb.A11yThemeMode.visit_ready_with_theme_mode(path, css(ready_sel), theme, mode)
            |> E2eWeb.A11yThemeMode.assert_document_theme_mode(theme, mode)
            |> Combobox.wait_playground_combobox_ready()

          sess =
            Combobox.check_accessibility(sess, css("#combobox-playground"),
              filter: E2eWeb.A11yDocPageFilter
            )

          sess
          |> Combobox.open_combobox_by_host_id("combobox-playground")
          |> Combobox.click_item_by_host_id("combobox-playground", "bel")
          |> Combobox.wait(200)
          |> then(
            &Combobox.check_accessibility(&1, css("#combobox-playground"),
              filter: E2eWeb.A11yDocPageFilter
            )
          )
      end
    end
  end
end
