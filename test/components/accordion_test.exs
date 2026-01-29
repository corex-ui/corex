defmodule Corex.AccordionTest do
  use ExUnit.Case, async: true

  alias Corex.Accordion
  alias Corex.Accordion.Connect

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
        disabled_root: false,
        changed: nil
      }

      result = Connect.item(assigns)

      assert result["id"] == "accordion:test-accordion:item:item-1"
      assert result["data-state"] == "closed"
      assert result["data-disabled"] == false
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
        disabled_root: false,
        changed: nil
      }

      result = Connect.trigger(assigns)

      assert result["aria-expanded"] == "true"
      assert result["data-state"] == "open"
      assert result["aria-controls"] == "accordion:test-accordion:content:item-1"
      assert result["data-controls"] == "accordion:test-accordion:content:item-1"
      assert result["data-ownedby"] == "accordion:test-accordion"
    end

    test "computes item data with disabled item" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: true,
        dir: "ltr",
        orientation: "vertical",
        changed: nil,
        disabled_root: false
      }

      result = Connect.item(assigns)

      assert result["data-disabled"] == true
    end

    test "computes item data with disabled parent" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil,
        disabled_root: true
      }

      result = Connect.item(assigns)
      assert result["data-disabled"] == true
    end

    test "generates item ID from value" do
      assigns = %{
        id: "test-accordion",
        value: "item-1",
        values: [],
        disabled: false,
        dir: "ltr",
        orientation: "vertical",
        changed: nil,
        disabled_root: false
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
        changed: nil,
        disabled_root: false
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

      assert trigger_attrs["aria-expanded"] == "true"
      assert trigger_attrs["data-state"] == "open"
      assert trigger_attrs["data-disabled"] == false
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
      assert content_attrs["data-disabled"] == false
      assert content_attrs["data-orientation"] == "vertical"
      assert content_attrs["hidden"] == false
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
      assert indicator_attrs["data-disabled"] == false
      assert indicator_attrs["data-orientation"] == "vertical"
    end
  end
end
