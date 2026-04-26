defmodule Corex.MenuTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Menu
  alias Corex.Menu.Connect

  describe "menu/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_menu/1, [])
      assert html =~ ~r/data-scope="menu"/
      assert html =~ ~r/menu:/
    end

    test "renders with grouped items" do
      html = render_component(&CorexTest.ComponentHelpers.render_menu_grouped/1, [])
      assert html =~ ~r/data-part="item-group"/
      assert html =~ ~r/data-part="item-group-label"/
    end

    test "renders with nested items and custom nested_indicator" do
      html = render_component(&CorexTest.ComponentHelpers.render_menu_nested/1, [])
      assert html =~ ~r/data-scope="menu"/
      assert html =~ ~r/Share/
      assert html =~ ~r/Messages/
    end

    test "renders data-loading on hook root" do
      html = render_component(&CorexTest.ComponentHelpers.render_menu_with_loading/1, [])
      assert html =~ ~r/data-loading/
      assert html =~ ~r/phx-mounted/
    end
  end

  describe "set_open/2" do
    test "returns JS command when open is true" do
      js = Menu.set_open("my-menu", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when open is false" do
      js = Menu.set_open("my-menu", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_open/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Menu.set_open(socket, "my-menu", false)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "m1", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["data-scope"] == "menu"
      assert result["data-part"] == "root"
      assert result["dir"] == "ltr"
    end

    test "computes root with rtl direction" do
      assigns = %{id: "m2", dir: "rtl"}
      result = Connect.root(assigns)
      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.trigger/1" do
    test "returns trigger attributes when enabled" do
      assigns = %{id: "test-menu", dir: "ltr", disabled: false}
      result = Connect.trigger(assigns)
      assert result["id"] == "menu:test-menu:trigger"
      assert result["data-scope"] == "menu"
      assert result["aria-disabled"] == "false"
      assert result["tabindex"] == 0
    end

    test "returns trigger attributes when disabled" do
      assigns = %{id: "test-menu", dir: "ltr", disabled: true}
      result = Connect.trigger(assigns)
      assert result["aria-disabled"] == "true"
      assert result["tabindex"] == -1
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attributes" do
      assigns = %{id: "test-menu", dir: "ltr"}
      result = Connect.indicator(assigns)
      assert result["data-scope"] == "menu"
      assert result["data-part"] == "indicator"
    end
  end

  describe "Connect.positioner/1" do
    test "returns positioner attributes with hidden until client opens" do
      assigns = %{id: "test-menu", dir: "ltr"}
      result = Connect.positioner(assigns)
      assert result["id"] == "menu:test-menu:positioner"
      assert result["hidden"] == "true"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{id: "test-menu", dir: "ltr"}
      result = Connect.content(assigns)
      assert result["id"] == "menu:test-menu:content"
      assert result["role"] == "menu"
      assert result["hidden"] == "true"
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes" do
      assigns = %{
        id: "test-menu",
        value: "item-1",
        dir: "ltr",
        disabled: false,
        nested_menu_id: nil,
        has_nested: false,
        redirect: true,
        new_tab: false
      }

      result = Connect.item(assigns)
      assert result["id"] == "menu:test-menu:item:item-1"
      assert result["data-value"] == "item-1"
      assert result["role"] == "menuitem"
    end
  end

  describe "Connect.separator/1" do
    test "returns separator attributes" do
      assigns = %{dir: "ltr"}
      result = Connect.separator(assigns)
      assert result["role"] == "separator"
    end
  end

  describe "Connect.props/1" do
    test "returns props with positioning dataset" do
      assigns = %{
        id: "test-menu",
        dir: "ltr",
        close_on_select: true,
        loop_focus: false,
        typeahead: true,
        composite: false,
        value: nil,
        aria_label: nil,
        on_select: nil,
        on_select_client: nil,
        redirect: false,
        on_open_change: nil,
        on_open_change_client: nil,
        positioning: %Corex.Positioning{placement: "bottom-start"}
      }

      result = Connect.props(assigns)
      assert result["id"] == "test-menu"
      assert result["data-position-placement"] == "bottom-start"
    end
  end

  describe "Connect.item_group_label/1" do
    test "returns item group label attributes" do
      assigns = %{id: "test-menu", group_id: "group-1", dir: "ltr"}
      result = Connect.item_group_label(assigns)
      assert result["data-part"] == "item-group-label"
    end
  end

  describe "Connect.item_group/1" do
    test "returns item group attributes" do
      assigns = %{id: "test-menu", group_id: "group-1", dir: "ltr"}
      result = Connect.item_group(assigns)
      assert result["data-part"] == "item-group"
    end
  end

  describe "Connect.nested_menu/1" do
    test "returns nested menu attributes" do
      assigns = %{id: "test-menu", dir: "ltr"}
      result = Connect.nested_menu(assigns)
      assert result["data-nested"] == "menu"
      assert result["data-scope"] == "menu"
    end
  end
end
