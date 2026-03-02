defmodule Corex.TabsTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Tabs
  alias Corex.Tabs.Connect

  describe "tabs/1" do
    test "renders with items" do
      html = render_component(&CorexTest.ComponentHelpers.render_tabs/1, [])
      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/Tab1/
    end

    test "renders with horizontal orientation" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_tabs/1, orientation: "horizontal")

      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/data-orientation="horizontal"/
    end

    test "renders with custom slots only" do
      html = render_component(&CorexTest.ComponentHelpers.render_tabs_custom_slots_only/1, [])
      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/Tab 1/
      assert html =~ ~r/Tab 2/
      assert html =~ ~r/Content 1/
      assert html =~ ~r/Content 2/
    end

    test "renders with items and custom trigger/content slots" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_tabs_items_with_custom_slots/1, [])

      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/A/
      assert html =~ ~r/B/
      assert html =~ ~r/A content/
      assert html =~ ~r/B content/
    end
  end

  describe "tabs_trigger/1" do
    test "renders trigger" do
      html = render_component(&CorexTest.ComponentHelpers.render_tabs_trigger/1, [])
      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/data-part="trigger"/
      assert html =~ ~r/Tab 1/
    end
  end

  describe "tabs_content/1" do
    test "renders content" do
      html = render_component(&CorexTest.ComponentHelpers.render_tabs_content/1, [])
      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/data-part="content"/
      assert html =~ ~r/Content 1/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = Tabs.set_value("my-tabs", "tab-1")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for nil to close all tabs" do
      js = Tabs.set_value("my-tabs", nil)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Tabs.set_value(socket, "my-tabs", "tab-1")
      assert %Phoenix.LiveView.Socket{} = result
    end

    test "pushes event to socket with nil to close all tabs" do
      socket = %Phoenix.LiveView.Socket{}
      result = Tabs.set_value(socket, "my-tabs", nil)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-tabs", dir: "ltr", orientation: "vertical"}
      result = Connect.root(assigns)
      assert result["id"] == "tabs:test-tabs"
      assert result["data-scope"] == "tabs"
      assert result["data-part"] == "root"
      assert result["data-orientation"] == "vertical"
    end

    test "computes root with horizontal orientation" do
      assigns = %{id: "test-tabs", dir: "ltr", orientation: "horizontal"}
      result = Connect.root(assigns)
      assert result["data-orientation"] == "horizontal"
    end

    test "computes root with rtl direction" do
      assigns = %{id: "test-tabs", dir: "rtl", orientation: "vertical"}
      result = Connect.root(assigns)
      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.list/1" do
    test "returns list attributes" do
      assigns = %{id: "test-tabs", dir: "ltr", orientation: "vertical"}
      result = Connect.list(assigns)
      assert result["id"] == "tabs:test-tabs:list"
      assert result["role"] == "tablist"
      assert result["data-orientation"] == "vertical"
    end
  end

  describe "Connect.trigger/1" do
    test "returns trigger attributes when selected" do
      assigns = %{
        id: "test-tabs",
        value: "tab-1",
        values: ["tab-1"],
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        data: %{}
      }

      result = Connect.trigger(assigns)
      assert result["id"] == "tabs:test-tabs:trigger:tab-1"
      assert result["aria-selected"] == "true"
      assert result["aria-expanded"] == "true"
      assert result["data-controls"] == "tabs:test-tabs:content:tab-1"
    end

    test "returns trigger attributes when not selected" do
      assigns = %{
        id: "test-tabs",
        value: "tab-1",
        values: ["tab-2"],
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        data: %{}
      }

      result = Connect.trigger(assigns)
      assert result["aria-selected"] == "false"
      assert result["aria-expanded"] == "false"
    end

    test "computes trigger with disabled state" do
      assigns = %{
        id: "test-tabs",
        value: "tab-1",
        values: [],
        dir: "ltr",
        orientation: "vertical",
        disabled: true,
        data: %{}
      }

      result = Connect.trigger(assigns)
      assert result["aria-disabled"] == "true"
      assert result["disabled"] == true
      assert result["tabindex"] == -1
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes when visible" do
      assigns = %{
        id: "test-tabs",
        value: "tab-1",
        values: ["tab-1"],
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        data: %{}
      }

      result = Connect.content(assigns)
      assert result["id"] == "tabs:test-tabs:content:tab-1"
      assert result["data-state"] == "open"
      assert result["hidden"] == false
    end

    test "returns content attributes when hidden" do
      assigns = %{
        id: "test-tabs",
        value: "tab-1",
        values: ["tab-2"],
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        data: %{}
      }

      result = Connect.content(assigns)
      assert result["hidden"] == true
      assert result["data-state"] == "closed"
    end
  end

  describe "Connect.props/1" do
    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-tabs",
        controlled: false,
        value: "tab-1",
        orientation: "vertical",
        dir: "ltr",
        on_value_change: nil,
        on_value_change_client: nil,
        on_focus_change: nil,
        on_focus_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-default-value"] == "tab-1"
      assert result["data-value"] == nil
    end

    test "returns props when controlled" do
      assigns = %{
        id: "test-tabs",
        controlled: true,
        value: "tab-1",
        orientation: "vertical",
        dir: "ltr",
        on_value_change: nil,
        on_value_change_client: nil,
        on_focus_change: nil,
        on_focus_change_client: nil
      }

      result = Connect.props(assigns)
      assert result["data-default-value"] == nil
      assert result["data-value"] == "tab-1"
    end
  end
end
