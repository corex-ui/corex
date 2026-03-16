defmodule Corex.CollapsibleTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Collapsible
  alias Corex.Collapsible.Connect

  describe "collapsible/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_collapsible/1, [])
      assert html =~ ~r/data-scope="collapsible"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with indicator slot" do
      html = render_component(&CorexTest.ComponentHelpers.render_collapsible_with_indicator/1, [])
      assert html =~ ~r/data-scope="collapsible"/
      assert html =~ ~r/data-part="indicator"/
      assert html =~ ~r/data-indicator/
      assert html =~ "Indicator"
    end

    test "renders with :let on trigger, content, and indicator" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_collapsible_with_let_slots/1,
          open: false
        )

      assert html =~ ~r/data-scope="collapsible"/
      assert html =~ "Expand"
      assert html =~ "Panel"
      assert html =~ ~r/data-indicator-state="closed"/

      html_open =
        render_component(&CorexTest.ComponentHelpers.render_collapsible_with_let_slots/1,
          open: true
        )

      assert html_open =~ "Collapse"
      assert html_open =~ ~r/data-indicator-state="open"/
    end
  end

  describe "set_open/2" do
    test "returns JS command when open is true" do
      js = Collapsible.set_open("my-collapsible", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when open is false" do
      js = Collapsible.set_open("my-collapsible", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_open/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Collapsible.set_open(socket, "my-collapsible", false)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes when closed" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: false}
      result = Connect.root(assigns)
      assert result["id"] == "collapsible:test-collapsible"
      assert result["data-scope"] == "collapsible"
      assert result["data-part"] == "root"
      assert result["data-state"] == "closed"
    end

    test "data-state is open when open is true" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: true}
      result = Connect.root(assigns)
      assert result["data-state"] == "open"
    end

    test "computes root with rtl direction" do
      assigns = %{id: "test-collapsible", dir: "rtl", open: false}
      result = Connect.root(assigns)
      assert result["dir"] == "rtl"
    end
  end

  describe "Connect.trigger/1" do
    test "returns trigger attributes when closed" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: false, disabled: false}
      result = Connect.trigger(assigns)
      assert result["id"] == "collapsible:test-collapsible:trigger"
      assert result["data-scope"] == "collapsible"
      assert result["aria-expanded"] == "false"
      assert result["data-state"] == "closed"
      assert result["aria-controls"] == "collapsible:test-collapsible:content"
    end

    test "returns trigger attributes when open" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: true, disabled: false}
      result = Connect.trigger(assigns)
      assert result["aria-expanded"] == "true"
      assert result["data-state"] == "open"
    end

    test "computes trigger with disabled state" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: false, disabled: true}
      result = Connect.trigger(assigns)
      assert result["aria-disabled"] == "true"
      assert result["disabled"] == true
      assert result["tabindex"] == -1
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes when closed" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: false, disabled: false}
      result = Connect.content(assigns)
      assert result["id"] == "collapsible:test-collapsible:content"
      assert result["data-state"] == "closed"
      assert result["hidden"] == true
    end

    test "returns content attributes when open" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: true, disabled: false}
      result = Connect.content(assigns)
      assert result["data-state"] == "open"
      assert result["hidden"] == false
    end
  end

  describe "Connect.indicator/1" do
    test "returns indicator attributes when closed" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: false, disabled: false}
      result = Connect.indicator(assigns)
      assert result["data-scope"] == "collapsible"
      assert result["data-part"] == "indicator"
      assert result["data-state"] == "closed"
      assert result["aria-hidden"] == true
    end

    test "returns indicator attributes when open" do
      assigns = %{id: "test-collapsible", dir: "ltr", open: true, disabled: false}
      result = Connect.indicator(assigns)
      assert result["data-state"] == "open"
    end
  end
end
