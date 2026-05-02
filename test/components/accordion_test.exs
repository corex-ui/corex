defmodule Corex.AccordionTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Accordion
  alias Corex.Accordion.Anatomy.Props
  alias Corex.Accordion.Connect

  describe "accordion/1" do
    test "renders with items" do
      items = Corex.Content.new([%{trigger: "T1", content: "C1"}])
      html = render_component(&Accordion.accordion/1, items: items)
      assert html =~ ~r/data-scope="accordion"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r//
      assert html =~ ~r/data-part="item-trigger"/
      assert html =~ ~r/data-part="item-content"/
      assert html =~ ~r/T1/
      assert html =~ ~r/C1/
    end

    test "renders with horizontal orientation" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_accordion/1,
          orientation: "horizontal"
        )

      assert html =~ ~r/data-scope="accordion"/
      assert html =~ ~r/data-orientation="horizontal"/
    end

    test "renders with collapsible false" do
      html = render_component(&CorexTest.ComponentHelpers.render_accordion/1, collapsible: false)
      assert html =~ ~r/data-scope="accordion"/
    end

    test "renders with multiple false" do
      html = render_component(&CorexTest.ComponentHelpers.render_accordion/1, multiple: false)
      assert html =~ ~r/data-scope="accordion"/
    end

    test "renders with dir rtl" do
      html = render_component(&CorexTest.ComponentHelpers.render_accordion/1, dir: "rtl")
      assert html =~ ~r/data-scope="accordion"/
      assert html =~ ~r/dir="rtl"/
    end

    test "renders with indicator slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_accordion_with_indicator/1, [])
      assert html =~ ~r/data-scope="accordion"/
      assert html =~ ~r/data-part="item-indicator"/
    end

    test "renders with custom trigger and content slots" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_accordion_with_custom_slots/1, [])

      assert html =~ ~r/data-scope="accordion"/
      assert html =~ ~r/data-trigger/
      assert html =~ ~r/data-content/
      assert html =~ ~r/Custom/
    end

    test "renders accordion_skeleton" do
      html = render_component(&Accordion.accordion_skeleton/1, [])
      assert html =~ ~r/data-scope="accordion"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with all attributes and custom slots and indicator" do
      items = Corex.Content.new([%{trigger: "T1", content: "C1"}])

      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Accordion.accordion
              id="acc1"
              items={@items}
              controlled={true}
              value={["item-0"]}
              collapsible={false}
              multiple={true}
              orientation="horizontal"
              dir="rtl"
              on_value_change="vchange"
              on_value_change_client="vcclient"
              on_focus_change="fchange"
              on_focus_change_client="fcclient"
            >
              <:trigger :let={item}>Custom Trigger {item.trigger}</:trigger>
              <:content :let={item}>Custom Content {item.content}</:content>
              <:indicator :let={_item}>Icon</:indicator>
            </Corex.Accordion.accordion>
            """
          end,
          %{items: items}
        )

      assert html =~ "Custom Trigger T1"
      assert html =~ "Custom Content C1"
      assert html =~ "Icon"
      assert html =~ "data-controlled"
    end

    test "renders manual trigger, content, and indicator slots without items" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Accordion.accordion id="acc-manual" class="accordion" value="lorem">
              <:trigger value="lorem">Trigger A</:trigger>
              <:content value="lorem"><span>Content A</span></:content>
              <:indicator value="lorem">Ind A</:indicator>
              <:trigger value="duis">Trigger B</:trigger>
              <:content value="duis"><span>Content B</span></:content>
            </Corex.Accordion.accordion>
            """
          end,
          %{}
        )

      assert html =~ "Trigger A"
      assert html =~ "Content A"
      assert html =~ "Ind A"
      assert html =~ "Trigger B"
      assert html =~ "Content B"
      assert html =~ ~s(data-value="lorem")
      assert html =~ ~s(data-value="duis")
    end

    test "manual mode raises when only :trigger slots are provided" do
      assert_raise ArgumentError, ~r/requires both :trigger and :content/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Accordion.accordion id="acc-bad" class="accordion">
              <:trigger value="lorem">Only trigger</:trigger>
            </Corex.Accordion.accordion>
            """
          end,
          %{}
        )
      end
    end

    test "manual mode raises when trigger and content values do not match" do
      assert_raise ArgumentError, ~r/must match exactly/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Accordion.accordion id="acc-bad" class="accordion">
              <:trigger value="lorem">T</:trigger>
              <:content value="other">C</:content>
            </Corex.Accordion.accordion>
            """
          end,
          %{}
        )
      end
    end

    test "manual mode raises on duplicate resolved trigger values" do
      assert_raise ArgumentError, ~r/duplicate value/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Accordion.accordion id="acc-bad" class="accordion">
              <:trigger value="same">T1</:trigger>
              <:trigger value="same">T2</:trigger>
              <:content value="same">C</:content>
            </Corex.Accordion.accordion>
            """
          end,
          %{}
        )
      end
    end

    test "manual mode raises when indicator value is unknown" do
      assert_raise ArgumentError, ~r/no matching required slot/, fn ->
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Accordion.accordion id="acc-bad" class="accordion">
              <:trigger value="lorem">T</:trigger>
              <:content value="lorem">C</:content>
              <:indicator value="orphan">I</:indicator>
            </Corex.Accordion.accordion>
            """
          end,
          %{}
        )
      end
    end
  end

  describe "set_value/2" do
    test "returns JS command with list of values" do
      js = Accordion.set_value("my-accordion", ["item-1", "item-2"])

      assert %Phoenix.LiveView.JS{} = js
    end

    test "raises error for invalid list values" do
      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Accordion.set_value("my-accordion", [1, 2, 3])
      end
    end

    test "accepts empty list values" do
      js = Accordion.set_value("my-accordion", [])

      assert %Phoenix.LiveView.JS{} = js
    end

    test "accepts comma-separated binary as list of ids" do
      js = Accordion.set_value("my-accordion", "item-1,item-2")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "accepts single binary id" do
      js = Accordion.set_value("my-accordion", "item-1")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "accepts empty binary as closed" do
      js = Accordion.set_value("my-accordion", "")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket with list of values" do
      socket = %Phoenix.LiveView.Socket{}
      result = Accordion.set_value(socket, "my-accordion", ["item-1", "item-2"])

      assert %Phoenix.LiveView.Socket{} = result
    end

    test "raises error for invalid list values" do
      socket = %Phoenix.LiveView.Socket{}

      assert_raise ArgumentError, ~r/value must be a list of strings/, fn ->
        Accordion.set_value(socket, "my-accordion", [1, 2, 3])
      end
    end

    test "accepts empty list values" do
      socket = %Phoenix.LiveView.Socket{}
      result = Accordion.set_value(socket, "my-accordion", [])

      assert %Phoenix.LiveView.Socket{} = result
    end

    test "accepts comma-separated binary" do
      socket = %Phoenix.LiveView.Socket{}
      result = Accordion.set_value(socket, "my-accordion", "a,b")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "value/1" do
    test "returns JS command" do
      js = Accordion.value("my-accordion")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "value/2" do
    test "pushes accordion_value event with id" do
      socket = %Phoenix.LiveView.Socket{}
      result = Accordion.value(socket, "my-accordion")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "focused/1" do
    test "returns JS command" do
      js = Accordion.focused("my-accordion")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "focused/2" do
    test "pushes accordion_focused event with id" do
      socket = %Phoenix.LiveView.Socket{}
      result = Accordion.focused(socket, "my-accordion")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "item_state/2 and item_state/3" do
    test "returns JS command with default disabled" do
      js = Accordion.item_state("my-accordion", "item-1")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command with disabled" do
      js = Accordion.item_state("my-accordion", "item-1", disabled: true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "raises for empty item value" do
      assert_raise ArgumentError, fn ->
        Accordion.item_state("my-accordion", "")
      end
    end
  end

  describe "item_state/3 and item_state/4" do
    test "pushes accordion_item_state with id, value, disabled default" do
      socket = %Phoenix.LiveView.Socket{}
      result = Accordion.item_state(socket, "my-accordion", "item-1")
      assert %Phoenix.LiveView.Socket{} = result
    end

    test "pushes accordion_item_state with disabled" do
      socket = %Phoenix.LiveView.Socket{}
      result = Accordion.item_state(socket, "my-accordion", "item-1", disabled: true)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.props/1" do
    test "maps multiple and collapsible to data attributes" do
      props_false = %Props{id: "a", multiple: false, collapsible: false, value: []}
      m = Connect.props(props_false)
      assert m["data-multiple"] == nil
      assert m["data-collapsible"] == nil

      props_true = %Props{id: "b", multiple: true, collapsible: true, value: ["item-0"]}
      m2 = Connect.props(props_true)
      assert m2["data-multiple"] == ""
      assert m2["data-collapsible"] == ""
    end

    test "includes event attribute names when set" do
      m =
        Connect.props(%Props{
          id: "c",
          value: [],
          on_value_change: "v",
          on_value_change_client: "vc",
          on_focus_change: "f",
          on_focus_change_client: "fc"
        })

      assert m["data-on-value-change"] == "v"
      assert m["data-on-value-change-client"] == "vc"
      assert m["data-on-focus-change"] == "f"
      assert m["data-on-focus-change-client"] == "fc"
    end

    test "does not merge animation_options when animation is not js" do
      m =
        Connect.props(%Props{
          id: "d",
          value: [],
          animation: "custom",
          animation_options: %Corex.Animation.Height{duration: 0.9}
        })

      assert m["data-animation"] == "custom"
      refute Map.has_key?(m, "data-anim-height-duration")
    end
  end

  describe "Connect.root/1" do
    test "root returns root attributes" do
      assigns = %{
        id: "test-accordion",
        value: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.root(assigns)

      assert result["id"] == "accordion:test-accordion"
      assert result["data-orientation"] == "vertical"
      assert result["dir"] == "ltr"
    end

    test "computes root context with initial values" do
      assigns = %{
        id: "test-accordion",
        value: ["item-1", "item-2"],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.root(assigns)

      assert result["id"] == "accordion:test-accordion"
      assert result["data-orientation"] == "vertical"
    end

    test "computes root context with single initial value" do
      assigns = %{
        id: "test-accordion",
        value: ["item-1"],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.root(assigns)

      assert result["id"] == "accordion:test-accordion"
      assert result["data-orientation"] == "vertical"
    end

    test "computes root context with custom id" do
      assigns = %{
        id: "test-accordion",
        value: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.root(assigns)

      assert result["id"] == "accordion:test-accordion"
    end

    test "computes root context with horizontal orientation" do
      assigns = %{
        id: "test-accordion",
        value: [],
        disabled: false,
        dir: "ltr",
        orientation: "horizontal",
        changed: nil
      }

      result = Connect.root(assigns)

      assert result["data-orientation"] == "horizontal"
    end

    test "computes root context with rtl direction" do
      assigns = %{
        id: "test-accordion",
        value: [],
        disabled: false,
        dir: "rtl",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.root(assigns)

      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.item/1" do
    test "item returns item attributes" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.item(assigns)

      assert result["id"] == "accordion:test-accordion:item:item-1"
      assert result["data-state"] == "closed"
      assert result["data-disabled"] == nil
      assert result["data-focus"] == nil
      assert result["data-orientation"] == "vertical"
    end

    test "trigger returns trigger attributes" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: ["item-1"],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.trigger(assigns)

      assert result["data-focus"] == nil
      assert result["aria-expanded"] == "true"
      assert result["aria-disabled"] == "false"
      assert result["data-state"] == "open"
      assert result["aria-controls"] == "accordion:test-accordion:content:item-1"
      assert result["data-controls"] == "accordion:test-accordion:content:item-1"
      assert result["data-ownedby"] == "accordion:test-accordion"
    end

    test "trigger marks disabled when item disabled" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: true,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.trigger(assigns)

      assert result["aria-disabled"] == "true"
      assert result["disabled"] == true
      assert result["aria-expanded"] == "false"
    end

    test "computes item data with disabled item" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: true,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.item(assigns)

      assert result["data-disabled"] == ""
    end

    test "generates item ID from value" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.item(assigns)

      assert result["id"] == "accordion:test-accordion:item:item-1"
    end

    test "generates item ID when value is provided" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      result = Connect.item(assigns)

      assert result["id"] == "accordion:test-accordion:item:item-1"
    end

    test "computes trigger data structure" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: ["item-1"],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      trigger_attrs = Connect.trigger(assigns)

      assert trigger_attrs["data-focus"] == nil
      assert trigger_attrs["aria-expanded"] == "true"
      assert trigger_attrs["aria-disabled"] == "false"
      assert trigger_attrs["data-state"] == "open"
      assert trigger_attrs["data-disabled"] == nil
      assert trigger_attrs["data-orientation"] == "vertical"
    end

    test "computes content data structure" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: ["item-1"],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      content_attrs = Connect.content(assigns)

      assert content_attrs["data-state"] == "open"
      assert content_attrs["data-disabled"] == nil
      assert content_attrs["data-focus"] == nil
      assert content_attrs["data-orientation"] == "vertical"
      assert content_attrs["aria-labelledby"] == "accordion:test-accordion:trigger:item-1"
      refute Map.has_key?(content_attrs, "hidden")
    end

    test "content closed instant uses hidden attribute" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      content_attrs = Connect.content(assigns, "instant")

      assert content_attrs["data-state"] == "closed"
      assert content_attrs["hidden"] == true
      assert content_attrs["aria-labelledby"] == "accordion:test-accordion:trigger:item-1"
    end

    test "content closed js omits hidden for SSR parity with client stripHiddenFromProps" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      content_attrs = Connect.content(assigns, "js")

      assert content_attrs["data-state"] == "closed"
      refute Map.has_key?(content_attrs, "hidden")
      assert content_attrs["aria-labelledby"] == "accordion:test-accordion:trigger:item-1"
    end

    test "content closed custom omits hidden" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      content_attrs = Connect.content(assigns, "custom")

      assert content_attrs["data-state"] == "closed"
      refute Map.has_key?(content_attrs, "hidden")
    end

    test "computes indicator data structure" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil
      }

      indicator_attrs = Connect.indicator(assigns)

      assert indicator_attrs["data-state"] == "closed"
      assert indicator_attrs["data-disabled"] == nil
      assert indicator_attrs["data-focus"] == nil
      assert indicator_attrs["data-orientation"] == "vertical"
    end
  end
end
