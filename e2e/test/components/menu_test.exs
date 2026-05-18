defmodule E2eWeb.MenuTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

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
        |> Menu.wait_section_menu_ready(section_id)
        |> Menu.open_menu_in_section(section_id)
        |> Menu.click_item_in_section(section_id, item_value, timeout: 8_000)
      end)
    end
  end

  describe "api" do
    feature "client binding  -  Open reveals menu content", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :api)
        |> Menu.wait_root_menu_ready("menu-api")

      session
      |> Menu.click_button_in_section("menu-api-binding", "Open")
      |> Menu.wait_for_has(
        css("#menu-api [data-scope='menu'][data-part='content'][data-state='open']",
          visible: :any
        ),
        timeout: 8_000
      )
    end

    feature "server  -  Open via LiveView reveals menu content", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :api)
        |> Menu.prepare_live_form()
        |> Menu.wait_root_menu_ready("menu-api-server")

      session
      |> Menu.click_button_in_section("menu-api-server-section", "Open")
      |> Menu.wait_for_has(
        css(
          "#menu-api-server [data-scope='menu'][data-part='content'][data-state='open']",
          visible: :any
        ),
        timeout: 8_000
      )
    end
  end

  describe "events" do
    feature "server  -  menu interaction appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :events)
        |> Menu.prepare_live_form()
        |> Menu.wait_root_menu_ready("menu-events-server")

      refute Menu.menu_events_server_log_has_row?(session)

      session
      |> Menu.open_menu_by_host_id("menu-events-server")
      |> Menu.click_item_in_section("menu-events-server-section", "menu", timeout: 8_000)
      |> Menu.wait_for_has(css("#menu-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Menu, :menu, :playground)
      |> Menu.wait_playground_menu_ready()
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
