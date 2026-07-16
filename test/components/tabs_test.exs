defmodule Corex.TabsTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Tabs
  alias Corex.Tabs.Anatomy.Content
  alias Corex.Tabs.Anatomy.Indicator
  alias Corex.Tabs.Anatomy.Trigger
  alias Corex.Tabs.Connect

  describe "tabs/1" do
    test "renders with items" do
      html = render_component(&CorexTest.ComponentHelpers.render_tabs/1, [])
      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r//
      assert html =~ ~r/phx-mounted=/
      assert html =~ ~r/Tab1/
    end

    test "renders with horizontal orientation" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_tabs/1, orientation: "horizontal")

      assert html =~ ~r/data-scope="tabs"/
      assert html =~ ~r/data-orientation="horizontal"/
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

    test "raises when items is not a list of Corex.Content.Item" do
      assert_raise ArgumentError, fn ->
        render_component(&Tabs.tabs/1,
          items: [[label: "T1", content: "C1"]]
        )
      end
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
      assert result["id"] == "tabs-test-tabs-root"
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

    test "omits dir when nil" do
      assigns = %{id: "test-tabs", dir: nil, orientation: "horizontal"}
      refute Map.has_key?(Connect.root(assigns), "dir")
    end
  end

  describe "tabs/1 dir attribute" do
    test "renders without dir when nil" do
      html =
        render_component(&Corex.Tabs.tabs/1, %{
          id: "t",
          items: Corex.Content.new([%{label: "A", content: "B"}]),
          dir: nil
        })

      refute html =~ ~S(dir="ltr")
      refute html =~ ~S(dir="rtl")
      refute html =~ ~S(data-dir="ltr")
      refute html =~ ~S(data-dir="rtl")
    end
  end

  describe "Connect.list/1" do
    test "returns list attributes" do
      assigns = %{id: "test-tabs", dir: "ltr", orientation: "vertical"}
      result = Connect.list(assigns)
      assert result["id"] == "tabs-test-tabs-list"
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
      assert result["id"] == "tabs-test-tabs-trigger-tab-1"
      assert result["aria-selected"] == "true"
      assert result["aria-expanded"] == "true"
      assert result["data-controls"] == "tabs-test-tabs-content-tab-1"
      assert result["aria-controls"] == "tabs-test-tabs-content-tab-1"
      assert result["data-ownedby"] == "tabs-test-tabs-list"
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
      assert result["data-disabled"] == ""
      assert result["tabindex"] == -1
    end

    test "omits data-disabled when not disabled" do
      assigns = %{
        id: "test-tabs",
        value: "tab-1",
        values: [],
        dir: "ltr",
        orientation: "vertical",
        disabled: false,
        data: %{}
      }

      result = Connect.trigger(assigns)
      assert result["data-disabled"] == nil
      assert result["disabled"] == false
    end
  end

  describe "Trigger.ignored_attrs/0" do
    test "allows LiveView to patch item disabled attrs on trigger" do
      ignored = Trigger.ignored_attrs()
      refute "data-disabled" in ignored
      refute "disabled" in ignored
      assert "aria-disabled" in ignored
      assert "tabindex" in ignored
    end
  end

  describe "Content.ignored_attrs/0" do
    test "allows LiveView to patch item data-disabled on content" do
      ignored = Content.ignored_attrs()
      refute "data-disabled" in ignored
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attributes when a tab is selected" do
      assigns = %Indicator{
        id: "test-tabs",
        values: ["tab-1"],
        dir: "ltr",
        orientation: "vertical"
      }

      result = Connect.indicator(assigns)
      assert result["data-scope"] == "tabs"
      assert result["data-part"] == "item-indicator"
      assert result["id"] == "tabs-test-tabs-indicator"
      assert result["data-state"] == "open"
    end

    test "returns indicator attributes when no tab is selected" do
      assigns = %Indicator{
        id: "test-tabs",
        values: [],
        dir: "ltr",
        orientation: "vertical"
      }

      result = Connect.indicator(assigns)
      assert result["data-state"] == "closed"
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
      assert result["id"] == "tabs-test-tabs-content-tab-1"
      assert result["role"] == "tabpanel"
      assert result["aria-labelledby"] == "tabs-test-tabs-trigger-tab-1"
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

    test "sets data-disabled when item disabled" do
      assigns = %{
        id: "test-tabs",
        value: "tab-1",
        values: ["tab-1"],
        dir: "ltr",
        orientation: "vertical",
        disabled: true,
        data: %{}
      }

      result = Connect.content(assigns)
      assert result["data-disabled"] == ""
    end
  end

  describe "Connect.props/1" do
    test "omits data-dir when nil" do
      assigns = %{
        id: "test-tabs",
        dir: nil,
        orientation: "horizontal",
        controlled: false,
        value: nil,
        on_value_change: nil,
        on_value_change_client: nil,
        on_focus_change: nil,
        on_focus_change_client: nil
      }

      refute Map.has_key?(Connect.props(assigns), "data-dir")
    end

    test "sets data-dir when explicit" do
      assigns = %{
        id: "test-tabs",
        dir: "rtl",
        orientation: "horizontal",
        controlled: false,
        value: nil,
        on_value_change: nil,
        on_value_change_client: nil,
        on_focus_change: nil,
        on_focus_change_client: nil
      }

      assert Connect.props(assigns)["data-dir"] == "rtl"
    end

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
