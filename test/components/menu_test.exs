defmodule Corex.MenuTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Menu
  alias Corex.Menu.Anatomy.{Item, Trigger}
  alias Corex.Menu.Connect

  describe "menu/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_menu/1, [])
      assert html =~ ~r/data-scope="menu"/
      assert html =~ ~r/menu:/
    end

    test "renders zag-aligned positioner and item ids" do
      html = render_component(&CorexTest.ComponentHelpers.render_menu/1, [])
      assert html =~ ~S(id="menu:test-menu:popper")
      assert html =~ ~S(id="test-menu/1")
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

    test "renders deep nested menu with grouped grandchildren" do
      items =
        Corex.Tree.new([
          %{
            label: "Share",
            value: "share",
            children: [
              %{
                label: "Social",
                value: "social",
                group: "Channels",
                children: [%{label: "Twitter", value: "twitter"}]
              },
              %{label: "Email", value: "email", group: "Channels"}
            ]
          },
          %{label: "Print", value: "print"}
        ])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu
              id="menu-deep"
              items={@items}
              redirect
              typeahead={false}
              loop_focus={true}
            >
              <:trigger>Actions</:trigger>
              <:nested_indicator>›</:nested_indicator>
            </Menu.menu>
            """
          end,
          %{items: items}
        )

      assert html =~ "Twitter"
      assert html =~ "Channels"
      assert html =~ "Print"
      assert html =~ ~S(data-nested="menu")
    end

    test "raises for invalid menu items" do
      assert_raise ArgumentError, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu id="bad-menu" items={[%{}]}>
              <:trigger>X</:trigger>
            </Menu.menu>
            """
          end,
          %{}
        )
      end
    end

    test "renders indicator slot on trigger" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu id="test-menu" items={Corex.Tree.new([%{label: "A", value: "a"}])}>
              <:trigger>Menu</:trigger>
              <:indicator>▼</:indicator>
            </Menu.menu>
            """
          end,
          %{}
        )

      assert html =~ "▼"
      assert html =~ ~S(data-part="indicator")
    end

    test "renders custom item slot" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu id="test-menu" items={Corex.Tree.new([%{label: "Plain", value: "plain"}])}>
              <:trigger>Menu</:trigger>
              <:item :let={item}>
                <span data-custom-item>{item.label}</span>
              </:item>
            </Menu.menu>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-custom-item)
      assert html =~ "Plain"
    end

    test "renders grouped children inside nested submenu" do
      items =
        Corex.Tree.new([
          %{
            label: "Share",
            value: "share",
            children: [
              %{label: "Twitter", value: "twitter", group: "Social"},
              %{label: "Email", value: "email", group: "Social"}
            ]
          }
        ])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu id="menu-nested-groups" items={@items}>
              <:trigger>Menu</:trigger>
              <:nested_indicator>›</:nested_indicator>
            </Menu.menu>
            """
          end,
          %{items: items}
        )

      assert html =~ "Twitter"
      assert html =~ "Social"
      assert html =~ ~S(data-part="item-group-label")
    end

    test "renders three-level nested menu with item slot in submenu" do
      items =
        Corex.Tree.new([
          %{
            label: "File",
            value: "file",
            children: [
              %{
                label: "Export",
                value: "export",
                children: [%{label: "PDF", value: "pdf"}, %{label: "CSV", value: "csv"}]
              }
            ]
          }
        ])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu id="menu-3-level" items={@items}>
              <:trigger>Menu</:trigger>
              <:nested_indicator>›</:nested_indicator>
              <:item :let={item}>
                <strong data-menu-item>{item.label}</strong>
              </:item>
            </Menu.menu>
            """
          end,
          %{items: items}
        )

      assert html =~ "PDF"
      assert html =~ ~S(data-menu-item)
      assert html =~ "Export"
    end

    test "renders top-level grouped item with nested children" do
      items =
        Corex.Tree.new([
          %{
            label: "More",
            value: "more",
            group: "Actions",
            children: [%{label: "Sub", value: "sub"}]
          }
        ])

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu id="menu-group-nested" items={@items}>
              <:trigger>Menu</:trigger>
              <:nested_indicator>›</:nested_indicator>
              <:item :let={item}>
                <em data-top-item>{item.label}</em>
              </:item>
            </Menu.menu>
            """
          end,
          %{items: items}
        )

      assert html =~ "Actions"
      assert html =~ ~S(data-top-item)
      assert html =~ "Sub"
    end

    test "renders disabled trigger and disabled item" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Menu.menu
              id="menu-disabled"
              disabled
              composite
              items={
                Corex.Tree.new([
                  %{label: "Off", value: "off", disabled: true},
                  %{label: "On", value: "on"}
                ])
              }
            >
              <:trigger>Menu</:trigger>
            </Menu.menu>
            """
          end,
          %{}
        )

      assert html =~ ~S(id="menu:menu-disabled:trigger")
      assert html =~ ~S(data-part="trigger" data-scope="menu" disabled)
      assert html =~ ~S(aria-disabled="true")
      refute html =~ ~S(data-part="trigger" data-scope="menu" data-disabled)
      assert html =~ ~S(id="menu-disabled/off")
      assert html =~ ~S(data-value="off" disabled)
      assert html =~ ~S(data-disabled="")
      assert html =~ "Off"
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
      refute result["disabled"]
      assert result["aria-disabled"] == "false"
      assert result["tabindex"] == 0
      refute Map.has_key?(result, "data-disabled")
    end

    test "returns trigger attributes when disabled" do
      assigns = %{id: "test-menu", dir: "ltr", disabled: true}
      result = Connect.trigger(assigns)
      assert result["disabled"]
      assert result["aria-disabled"] == "true"
      assert result["tabindex"] == -1
      refute Map.has_key?(result, "data-disabled")
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
      assert result["id"] == "menu:test-menu:popper"
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
      assert result["id"] == "test-menu/item-1"
      assert result["data-value"] == "item-1"
      assert result["role"] == "menuitem"
      refute result["disabled"]
      assert result["data-disabled"] == nil
    end

    test "returns item attributes when disabled" do
      assigns = %{
        id: "test-menu",
        value: "item-1",
        dir: "ltr",
        disabled: true,
        nested_menu_id: nil,
        has_nested: false,
        redirect: false,
        new_tab: false
      }

      result = Connect.item(assigns)
      assert result["disabled"]
      assert result["data-disabled"] == ""
    end

    test "emits data-to / data-redirect / data-new-tab" do
      result =
        Connect.item(%{
          id: "test-menu",
          value: "item-1",
          to: "/docs",
          dir: "ltr",
          disabled: false,
          nested_menu_id: nil,
          has_nested: false,
          redirect: :navigate,
          new_tab: true
        })

      assert result["data-to"] == "/docs"
      assert result["data-redirect"] == "navigate"
      assert result["data-new-tab"] == ""
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

  describe "Trigger.ignored_attrs/0" do
    test "allows LiveView to patch only native disabled on trigger" do
      ignored = Trigger.ignored_attrs()
      refute "disabled" in ignored
      assert "data-disabled" in ignored
      assert "aria-disabled" in ignored
      assert "tabindex" in ignored
    end
  end

  describe "Item.ignored_attrs/0" do
    test "allows LiveView to patch only native disabled on items" do
      ignored = Item.ignored_attrs()
      refute "disabled" in ignored
      assert "data-disabled" in ignored
      assert "aria-disabled" in ignored
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

  describe "Connect ignore helpers" do
    test "returns JS for hook and anatomy ignore functions" do
      id = "menu-ignore"
      dir = "ltr"
      orientation = "horizontal"

      assert %Phoenix.LiveView.JS{} = Connect.ignore_hook(id)

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_root(%{id: id, dir: dir, orientation: orientation})

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_trigger(%{
                 id: id,
                 disabled: false,
                 dir: dir,
                 orientation: orientation
               })

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_indicator(%{id: id, dir: dir, orientation: orientation})

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_positioner(%{id: id, dir: dir, orientation: orientation})

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_content(%{id: id, dir: dir, orientation: orientation})

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_item(%{
                 id: id,
                 value: "v",
                 dir: dir,
                 disabled: false,
                 nested_menu_id: nil,
                 has_nested: false,
                 redirect: false,
                 new_tab: false
               })

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_item_group(%{
                 id: id,
                 group_id: "g1",
                 dir: dir,
                 orientation: orientation
               })

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_item_group_label(%{
                 id: id,
                 group_id: "g1",
                 dir: dir,
                 orientation: orientation
               })
    end
  end
end
