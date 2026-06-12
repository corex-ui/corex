defmodule E2eWeb.MenuTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.MenuModel, as: Menu

  @moduletag :menu

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section opens menu and selects item", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Menu, :menu, :anatomy)

      Enum.reduce(Menu.anatomy_section_ids(), session, fn section_id, sess ->
        item_value =
          case section_id do
            "menu-anatomy-grouped" -> "combobox"
            "menu-anatomy-nested" -> "listbox"
            "menu-anatomy-nested-grouped" -> "tabs"
            _ -> "select"
          end

        sess
        |> Menu.wait_host_menu_ready(section_id)
        |> Menu.open_menu_by_host_id(section_id)
        |> Menu.click_item_in_section(section_id, item_value, timeout: 8_000)
      end)
    end
  end

  describe "api" do
    feature "client binding  -  Open reveals menu content", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :api)
      |> Menu.wait_root_menu_ready("menu-api")
      |> Menu.click_button_in_section("menu-api-binding", "Open")
      |> Menu.wait_menu_content_open("menu-api", timeout: 8_000)
    end

    feature "server  -  Open via LiveView reveals menu content", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :api)
      |> Menu.prepare_live_form()
      |> Menu.wait_root_menu_ready("menu-api-server")
      |> Menu.click_button_in_section("menu-api-server-section", "Open")
      |> Menu.wait_menu_content_open("menu-api-server", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  menu interaction appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :events)
        |> Menu.prepare_live_form()
        |> Menu.wait_root_menu_ready("menu-events-server")

      session =
        session
        |> Menu.open_menu_by_host_id("menu-events-server", timeout: 8_000)

      before_select = Menu.log_row_count(session, "menu-events-log-server")

      session
      |> Menu.click_item_in_section("menu-events-server-section", "menu", timeout: 8_000)
      |> Menu.wait_log_rows_grew("menu-events-log-server", before_select, timeout: 10_000)
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :playground)
      |> Menu.wait_playground_menu_ready()
    end

    feature "disabled switch syncs trigger aria-disabled and tabindex", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :playground)
      |> Menu.prepare_live_form()
      |> Menu.wait_playground_menu_ready()
      |> Menu.assert_trigger_enabled("menu-playground", timeout: 8_000)
      |> Menu.click_playground_disabled_switch()
      |> Menu.assert_trigger_disabled("menu-playground", timeout: 8_000)
      |> Menu.click_playground_disabled_switch()
      |> Menu.assert_trigger_enabled("menu-playground", timeout: 8_000)
    end

    feature "stays anchored and interactive after LiveView patch while open", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :playground)
      |> Menu.prepare_live_form()
      |> Menu.wait_playground_menu_ready()
      |> Menu.open_menu_by_host_id("menu-playground", timeout: 8_000)
      |> Menu.click_item_by_host_id("menu-playground", "listbox", timeout: 8_000)
      |> Menu.wait_playground_selected("listbox", timeout: 8_000)
      |> Menu.wait_menu_content_open("menu-playground", timeout: 8_000)
      |> Menu.assert_positioner_anchored("menu-playground")
      |> Menu.click_item_by_host_id("menu-playground", "tabs", timeout: 8_000)
      |> Menu.wait_playground_selected("tabs", timeout: 8_000)
      |> Menu.wait_menu_content_open("menu-playground", timeout: 8_000)
      |> Menu.assert_positioner_anchored("menu-playground")
    end
  end

  describe "patterns" do
    feature "patterns doc page is ready", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :patterns)
      |> Menu.wait_patterns_page()
    end
  end
end
