defmodule Corex.ListboxTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Listbox
  alias Corex.Listbox.Connect

  describe "listbox/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox/1, [])
      assert html =~ ~r/data-scope="listbox"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with all attributes and slots" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Listbox.listbox id="test-listbox" 
              items={[%{value: "1", label: "One", disabled: true, group: "G"}, %{value: "2", label: "Two", group: "G"}]}
              controlled={true}
              disabled={true}
              dir="rtl"
              orientation="horizontal"
              loop_focus={true}
              selection_mode="multiple"
              select_on_highlight={true}
              deselectable={true}
              typeahead={true}
              on_value_change="change"
              on_value_change_client="change_client"
              aria_label="Listbox"
            >
              <:label>Label</:label>
              <:item :let={%{label: label}}>Item {label}</:item>
              <:item_indicator>Selected</:item_indicator>
              <:empty>No items</:empty>
            </Corex.Listbox.listbox>
            """
          end,
          %{}
        )

      assert html =~ "Label"
      assert html =~ "Item One"
      assert html =~ "Selected"
      assert html =~ "data-disabled"
      assert html =~ "data-orientation=\"horizontal\""
    end

    test "renders empty slot" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Listbox.listbox id="test-listbox" items={[]}>
              <:empty>Empty state</:empty>
            </Corex.Listbox.listbox>
            """
          end,
          %{}
        )

      assert html =~ "Empty state"
      assert html =~ "data-part=\"empty\""
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-listbox", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "listbox:test-listbox"
      assert result["data-scope"] == "listbox"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{id: "test-listbox", dir: "ltr"}
      result = Connect.label(assigns)
      assert result["id"] == "listbox:test-listbox:label"
      assert result["data-part"] == "label"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{id: "test-listbox", dir: "ltr"}
      result = Connect.content(assigns)
      assert result["id"] == "listbox:test-listbox:content"
    end
  end

  describe "Connect.item_group/1" do
    test "returns item group attributes" do
      assigns = %{id: "test-listbox", group_id: "g1"}
      result = Connect.item_group(assigns)
      assert result["id"] == "listbox:test-listbox:item-group:g1"
      assert result["data-part"] == "item-group"
      assert result["data-id"] == "g1"
    end
  end

  describe "Connect.item_group_label/1" do
    test "returns item group label attributes" do
      assigns = %{id: "test-listbox", html_for: "g1"}
      result = Connect.item_group_label(assigns)
      assert result["id"] == "listbox:test-listbox:item-group-label:g1"
      assert result["data-part"] == "item-group-label"
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes" do
      assigns = %{id: "test-listbox", value: "opt1"}
      result = Connect.item(assigns)
      assert result["id"] == "listbox:test-listbox:item:opt1"
      assert result["data-part"] == "item"
      assert result["data-value"] == "opt1"
    end

    test "includes redirect and to when set" do
      assigns = %{
        id: "lb",
        value: "p",
        dir: "ltr",
        orientation: "vertical",
        to: "/path",
        redirect: :patch,
        new_tab: true
      }

      result = Connect.item(assigns)
      assert result["data-to"] == "/path"
      assert result["data-redirect"] == "patch"
      assert result["data-new-tab"] == ""
    end

    test "omits data-to for disallowed href" do
      assigns = %{
        id: "lb",
        value: "p",
        dir: "ltr",
        orientation: "vertical",
        to: "javascript:alert(1)"
      }

      result = Connect.item(assigns)
      refute Map.has_key?(result, "data-to")
    end
  end

  describe "Connect.item_text/1" do
    test "returns item text attributes" do
      assigns = %{id: "test-listbox", item: %{value: "x", label: "X"}}
      result = Connect.item_text(assigns)
      assert result["id"] == "listbox:test-listbox:item-text:x"
      assert result["data-part"] == "item-text"
    end

    test "uses value when item has value key" do
      assigns = %{id: "test-listbox", item: %{value: "v1", label: "L"}}
      result = Connect.item_text(assigns)
      assert result["id"] == "listbox:test-listbox:item-text:v1"
    end
  end

  describe "Connect.item_indicator/1" do
    test "returns item indicator attributes" do
      assigns = %{id: "test-listbox", item: %{value: "y", label: "Y"}}
      result = Connect.item_indicator(assigns)
      assert result["id"] == "listbox:test-listbox:item-indicator:y"
      assert result["data-part"] == "item-indicator"
    end
  end

  describe "Connect.props/1" do
    test "returns props when controlled" do
      assigns = %{
        id: "test-listbox",
        items: [%{value: "a", label: "A"}],
        controlled: true,
        value: ["a"],
        dir: "ltr",
        orientation: "vertical",
        loop_focus: false,
        selection_mode: "single",
        select_on_highlight: false,
        deselectable: false,
        typeahead: false,
        disabled: false,
        on_value_change: nil,
        on_value_change_client: nil,
        redirect: false
      }

      result = Connect.props(assigns)
      assert result["data-value"] == ~S(["a"])
      assert result["data-controlled"] == ""
    end

    test "returns props when uncontrolled" do
      assigns = %{
        id: "test-listbox",
        items: [%{value: "a", label: "A"}],
        controlled: false,
        value: ["a"],
        dir: "ltr",
        orientation: "vertical",
        loop_focus: false,
        selection_mode: "single",
        select_on_highlight: false,
        deselectable: false,
        typeahead: false,
        disabled: false,
        on_value_change: nil,
        on_value_change_client: nil,
        redirect: false
      }

      result = Connect.props(assigns)
      assert result["data-default-value"] == ~S(["a"])
      assert result["data-value"] == nil
    end
  end

  describe "listbox/1 with options" do
    test "renders with grouped collection" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox_grouped/1, [])

      groups = find_in_html(html, ~S([data-scope="listbox"][data-part="item-group"]))
      assert length(groups) == 2

      assert Enum.sort(Floki.attribute(groups, "data-id")) == ["Asia", "Europe"]

      labels = find_in_html(html, ~S([data-scope="listbox"][data-part="item-group-label"]))
      assert length(labels) == 2
      assert Enum.sort(Enum.map(labels, &Floki.text/1)) == ["Asia", "Europe"]

      items = find_in_html(html, ~S([data-scope="listbox"][data-part="item"]))
      assert length(items) == 2
      assert Enum.sort(Floki.attribute(items, "data-value")) == ["a1", "e1"]
      assert text_in_html(html) =~ "E1"
      assert text_in_html(html) =~ "A1"
    end

    test "renders with controlled" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox_controlled/1, [])
      assert html =~ ~r/data-scope="listbox"/
      assert html =~ ~r/data-controlled/
    end

    test "renders with Corex.List.Item collection" do
      html = render_component(&CorexTest.ComponentHelpers.render_listbox_list_items/1, [])
      assert html =~ ~r/data-scope="listbox"/
      assert html =~ ~r/Item 1/
      assert html =~ ~r/Item 2/
    end

    test "renders aria_label when label slot is omitted" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Listbox.listbox
              id="lb-aria"
              aria_label="Countries"
              items={Corex.List.new([%{label: "France", value: "fra"}])}
            />
            """
          end,
          %{}
        )

      assert html =~ "Countries"
      assert html =~ ~S(aria-labelledby="listbox:lb-aria:label")
    end

    test "renders ungrouped items without custom item slot" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Listbox.listbox
              id="lb-plain"
              items={Corex.List.new([%{label: "One", value: "1"}, %{label: "Two", value: "2"}])}
            />
            """
          end,
          %{}
        )

      assert html =~ "One"
      assert html =~ "Two"
      refute html =~ ~S(data-part="item-group")
    end

    test "marks disabled items and shows selected indicator" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Listbox.listbox
              id="lb-sel"
              value={["a"]}
              items={
                Corex.List.new([
                  %{label: "A", value: "a"},
                  %{label: "B", value: "b", disabled: true, to: "/b", redirect: :patch, new_tab: true}
                ])
              }
            >
              <:item_indicator>✓</:item_indicator>
            </Corex.Listbox.listbox>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-disabled)
      assert html =~ ~S(data-to="/b")
      assert html =~ "✓"
    end

    test "renders custom item slot on ungrouped list" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Listbox.listbox
              id="lb-custom"
              items={Corex.List.new([%{label: "France", value: "fra"}])}
            >
              <:item :let={%{label: label}}>Flag {label}</:item>
            </Corex.Listbox.listbox>
            """
          end,
          %{}
        )

      assert html =~ "Flag France"
    end
  end

  describe "Connect ignore helpers" do
    test "return JS for all ignore functions" do
      base = %{
        id: "lb",
        dir: "ltr",
        orientation: "vertical",
        group_id: "g",
        html_for: "g",
        item: %{value: "x", label: "X"},
        index: 0,
        value: "x"
      }

      for fun <- [
            &Connect.ignore_root/1,
            &Connect.ignore_label/1,
            &Connect.ignore_content/1,
            &Connect.ignore_item_group/1,
            &Connect.ignore_item_group_label/1,
            &Connect.ignore_item/1,
            &Connect.ignore_item_text/1,
            &Connect.ignore_item_indicator/1
          ] do
        assert %Phoenix.LiveView.JS{} = fun.(base)
      end
    end
  end

  describe "set_value/2 and set_value/3" do
    test "returns JS and pushes socket event" do
      assert %Phoenix.LiveView.JS{} = Listbox.set_value("lb", ["a"])
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Listbox.set_value(socket, "lb", ["a", "b"])
    end
  end

  describe "value/1 value/2 value/3 value/4" do
    test "returns JS and pushes socket event" do
      assert %Phoenix.LiveView.JS{} = Listbox.value("lb")
      assert %Phoenix.LiveView.JS{} = Listbox.value("lb", respond_to: :client)

      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Listbox.value(socket, "lb")
      assert %Phoenix.LiveView.Socket{} = Listbox.value(socket, "lb", respond_to: :both)
    end
  end
end
