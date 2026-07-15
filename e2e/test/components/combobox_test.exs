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
  end

  describe "patterns" do
    feature "server filter combobox is interactive", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :patterns)
      |> Combobox.wait_patterns_page()
      |> Combobox.wait_root_combobox_ready("combobox-patterns-server-filter-field")
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
