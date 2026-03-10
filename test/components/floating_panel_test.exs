defmodule Corex.FloatingPanelTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.FloatingPanel.Connect

  describe "floating_panel/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_floating_panel/1, [])
      assert html =~ ~r/data-scope="floating-panel"/
      assert html =~ ~r/data-part="root"/
    end

    test "renders with all attributes and custom translation" do
      translation = %Corex.FloatingPanel.Translation{
        minimize: "Min",
        maximize: "Max",
        restore: "Rest",
        close: "Cls"
      }

      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.FloatingPanel.floating_panel
              id="test-panel-full"
              open={true}
              controlled={true}
              draggable={false}
              resizable={false}
              allow_overflow={false}
              close_on_escape={false}
              disabled={true}
              dir="rtl"
              size={%{width: 200, height: 200}}
              default_size={%{width: 300, height: 300}}
              position={%{x: 10, y: 10}}
              default_position={%{x: 20, y: 20}}
              min_size={%{width: 100, height: 100}}
              max_size={%{width: 500, height: 500}}
              persist_rect={true}
              grid_size={10}
              on_open_change="open_change"
              on_open_change_client="open_change_client"
              on_position_change="pos_change"
              on_size_change="size_change"
              on_stage_change="stage_change"
              translation={@translation}
            >
              <:open_trigger>Open</:open_trigger>
              <:closed_trigger>Closed</:closed_trigger>
              <:minimize_trigger>MinBtn</:minimize_trigger>
              <:maximize_trigger>MaxBtn</:maximize_trigger>
              <:default_trigger>DefBtn</:default_trigger>
              <:close_trigger>ClsBtn</:close_trigger>
              <:content>Panel Content</:content>
            </Corex.FloatingPanel.floating_panel>
            """
          end,
          %{translation: translation}
        )

      assert html =~ "Open"
      assert html =~ "Closed"
      assert html =~ "MinBtn"
      assert html =~ "MaxBtn"
      assert html =~ "DefBtn"
      assert html =~ "ClsBtn"
      assert html =~ "Panel Content"
      assert html =~ "aria-label=\"Min\""
      assert html =~ "aria-label=\"Max\""
      assert html =~ "aria-label=\"Rest\""
      assert html =~ "aria-label=\"Cls\""
      assert html =~ "data-disabled"
      assert html =~ "data-dir=\"rtl\""
      assert html =~ ~s(&quot;width&quot;:200) and html =~ ~s(&quot;height&quot;:200)
      assert html =~ ~s(&quot;x&quot;:10) and html =~ ~s(&quot;y&quot;:10)
      assert html =~ "data-grid-size=\"10\""
      assert html =~ "data-persist-rect"
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-panel", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "floating-panel:test-panel"
      assert result["data-scope"] == "floating-panel"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.trigger/1" do
    test "returns trigger attributes when closed" do
      assigns = %{id: "test-panel", initial_open: false}
      result = Connect.trigger(assigns)
      assert result["id"] == "floating-panel:test-panel:trigger"
      assert result["data-state"] == "closed"
    end

    test "returns trigger attributes when open" do
      assigns = %{id: "test-panel", initial_open: true}
      result = Connect.trigger(assigns)
      assert result["data-state"] == "open"
    end
  end
end
