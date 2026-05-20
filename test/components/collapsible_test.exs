defmodule Corex.CollapsibleTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Collapsible
  alias Corex.Collapsible.Anatomy.{Closed, Opened}
  alias Corex.Collapsible.Connect

  describe "collapsible/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_collapsible/1, [])
      assert html =~ ~r/data-scope="collapsible"/
      assert html =~ ~r/data-part="root"/
      refute html =~ ~r/data-part="closed"/
    end

    test "renders with :closed slot" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_collapsible_with_closed_surface/1, [])

      assert html =~ ~r/data-scope="collapsible"/
      assert html =~ ~r/data-part="closed"/
      assert html =~ "Closed surface"
    end

    test "renders with :let on trigger, content, and :closed" do
      html =
        render_component(&CorexTest.ComponentHelpers.render_collapsible_with_let_slots/1,
          open: false
        )

      assert html =~ ~r/data-scope="collapsible"/
      assert html =~ "Expand"
      assert html =~ "Panel"
      assert html =~ ~r/data-closed-state="closed"/

      html_open =
        render_component(&CorexTest.ComponentHelpers.render_collapsible_with_let_slots/1,
          open: true
        )

      assert html_open =~ "Collapse"
      assert html_open =~ ~r/data-closed-state="open"/
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

  describe "Connect.props/1" do
    test "maps controlled and uncontrolled open state" do
      controlled =
        Connect.props(%{
          id: "c",
          open: true,
          controlled: true,
          disabled: false,
          dir: "ltr",
          orientation: "horizontal",
          on_open_change: "open_evt",
          on_open_change_client: "open_client"
        })

      assert controlled["data-open"] == ""
      assert controlled["data-controlled"] == ""
      assert controlled["data-default-open"] == nil

      uncontrolled =
        Connect.props(%{
          id: "c",
          open: false,
          controlled: false,
          disabled: false,
          dir: "ltr",
          orientation: "vertical",
          on_open_change: nil,
          on_open_change_client: nil
        })

      assert uncontrolled["data-default-open"] == nil
      assert uncontrolled["data-open"] == nil
    end
  end

  describe "Connect ignore helpers" do
    test "return JS for all ignore functions" do
      base = %{id: "c", dir: "ltr", open: true, disabled: false, orientation: "vertical"}

      for fun <- [
            &Connect.ignore_root/1,
            &Connect.ignore_trigger/1,
            &Connect.ignore_content/1,
            &Connect.ignore_closed_part/1,
            &Connect.ignore_opened_part/1
          ] do
        assert %Phoenix.LiveView.JS{} = fun.(base)
      end
    end
  end

  describe "collapsible_skeleton/1" do
    test "renders skeleton markup" do
      html =
        render_component(&Collapsible.collapsible_skeleton/1,
          id: "test-collapsible",
          class: "collapsible"
        )

      assert html =~ "data-loading"
      assert html =~ ~r/data-scope="collapsible"/
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

  describe "Connect.closed_part/1" do
    test "returns closed surface attributes" do
      assigns = %Closed{id: "x", dir: "ltr", disabled: false, orientation: "vertical"}
      result = Connect.closed_part(assigns)
      assert result["data-scope"] == "collapsible"
      assert result["data-part"] == "closed"
      assert result["id"] == "collapsible:x:closed"
      assert result["aria-hidden"] == true
    end
  end

  describe "Connect.opened_part/1" do
    test "returns opened surface attributes" do
      assigns = %Opened{id: "x", dir: "rtl", disabled: true, orientation: "horizontal"}
      result = Connect.opened_part(assigns)
      assert result["data-scope"] == "collapsible"
      assert result["data-part"] == "opened"
      assert result["id"] == "collapsible:x:opened"
      assert result["dir"] == "rtl"
    end
  end
end
