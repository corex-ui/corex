defmodule E2eWeb.ComboboxTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query
  import Wallaby.Browser

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

      Combobox.wait_hidden_value_by_host_id(session, "combobox-api-sv-client", "bel", timeout: 8_000)
    end

    feature "set value (server)  -  Belgium via LiveView", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :api)
        |> Combobox.wait_root_combobox_ready("combobox-api-sv-server")

      refute Combobox.hidden_input_value_by_host_id(session, "combobox-api-sv-server") == "bel"

      session
      |> Combobox.click_button_in_section("combobox-api-set-value-server", "Belgium")

      Combobox.wait_hidden_value_by_host_id(session, "combobox-api-sv-server", "bel", timeout: 8_000)
    end

    feature "set value (js)  -  Germany via dispatch", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :api)
        |> Combobox.wait_root_combobox_ready("combobox-api-sv-js")

      refute Combobox.hidden_input_value_by_host_id(session, "combobox-api-sv-js") == "deu"

      session
      |> click(
        xpath(
          "//*[@id='combobox-api-set-value-js']//button[contains(normalize-space(), 'Germany')]"
        )
      )

      Combobox.wait_hidden_value_by_host_id(session, "combobox-api-sv-js", "deu", timeout: 8_000)
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :playground)
      |> Combobox.wait_playground_combobox_ready()
    end
  end

  describe "patterns" do
    feature "controlled  -  selecting Belgium updates state text", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Combobox, :combobox, :patterns)
        |> Combobox.wait_patterns_page()
        |> Combobox.wait_root_combobox_ready("combobox-patterns-controlled-field")

      assert String.contains?(Combobox.controlled_patterns_state_text(session), "deu")

      session
      |> Combobox.open_combobox_by_host_id("combobox-patterns-controlled-field")
      |> Combobox.click_item_by_host_id("combobox-patterns-controlled-field", "bel")
      |> Combobox.wait_patterns_state_contains("bel", timeout: 12_000)

      assert String.contains?(Combobox.controlled_patterns_state_text(session), "bel")
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
          |> then(&Combobox.check_accessibility(&1, css("#combobox-playground"),
                    filter: E2eWeb.A11yDocPageFilter
                  ))
      end
    end
  end
end
