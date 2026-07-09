defmodule Corex.FloatingPanelTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.FloatingPanel
  alias Corex.FloatingPanel.Connect

  describe "floating_panel/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_floating_panel/1, [])
      assert html =~ ~r/data-scope="floating-panel"/
      assert html =~ ~r/data-part="root"/
      assert html =~ "Title"
      assert html =~ ~S(data-part="stage-trigger")
    end

    test "omits stage trigger buttons when stage slots are absent" do
      html =
        render_component(
          &CorexTest.ComponentHelpers.render_floating_panel_without_stage_triggers/1,
          []
        )

      assert html =~ "No stages"
      refute html =~ ~S(data-part="stage-trigger")
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
              draggable={false}
              resizable={false}
              allow_overflow={false}
              close_on_escape={false}
              disabled={true}
              dir="rtl"
              value_size={%{width: 200, height: 200}}
              size={%{width: 300, height: 300}}
              position={%{x: 20, y: 20}}
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
              <:trigger>
                <span data-open>Open</span>
                <span data-closed>Closed</span>
              </:trigger>
              <:title>Panel title</:title>
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
      assert html =~ "Panel title"
      assert html =~ "Panel Content"
      assert html =~ "aria-label=\"Min\""
      assert html =~ "aria-label=\"Max\""
      assert html =~ "aria-label=\"Rest\""
      assert html =~ "aria-label=\"Cls\""
      assert html =~ "data-disabled"
      assert html =~ "data-dir=\"rtl\""
      assert html =~ ~S(&quot;width&quot;:200) and html =~ ~S(&quot;height&quot;:200)
      assert html =~ ~S(&quot;x&quot;:20) and html =~ ~S(&quot;y&quot;:20)
      assert html =~ "data-grid-size=\"10\""
      assert html =~ "data-persist-rect"
    end

    test "merges positioning dataset for anchor placement" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.FloatingPanel.floating_panel
              id="panel-anchor"
              positioning={%Corex.Positioning{placement: "bottom-start", gutter: 16}}
            >
              <:trigger>
                <span data-open>Open</span>
                <span data-closed>Closed</span>
              </:trigger>
              <:title>T</:title>
              <:close_trigger>X</:close_trigger>
              <:content>C</:content>
            </Corex.FloatingPanel.floating_panel>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-position-placement="bottom-start")
      assert html =~ ~S(data-position-gutter="16")
    end

    test "applies class from trigger slot to button" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.FloatingPanel.floating_panel id="panel-trigger-class">
              <:trigger class="button button--variant-ghost button--sm">
                Trigger label
              </:trigger>
              <:title>T</:title>
              <:close_trigger>X</:close_trigger>
              <:content>C</:content>
            </Corex.FloatingPanel.floating_panel>
            """
          end,
          %{}
        )

      assert html =~ ~S(class="button button--variant-ghost button--sm")
      assert html =~ "Trigger label"
    end
  end

  describe "set_open/2" do
    test "returns JS command when open is true" do
      js = FloatingPanel.set_open("my-floating-panel", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when open is false" do
      js = FloatingPanel.set_open("my-floating-panel", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_open/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = FloatingPanel.set_open(socket, "my-floating-panel", false)
      assert %Phoenix.LiveView.Socket{} = result
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
    test "returns trigger attributes closed for SSR" do
      assigns = %{id: "test-panel", dir: "ltr", orientation: "vertical"}
      result = Connect.trigger(assigns)
      assert result["id"] == "floating-panel:test-panel:trigger"
      assert result["data-state"] == "closed"
    end
  end

  describe "Connect.props/1" do
    test "includes client event attribute names when set" do
      result =
        Connect.props(%Corex.FloatingPanel.Anatomy.Props{
          id: "panel-events",
          on_position_change_client: "pos_client",
          on_size_change_client: "size_client",
          on_stage_change_client: "stage_client"
        })

      assert result["data-on-position-change-client"] == "pos_client"
      assert result["data-on-size-change-client"] == "size_client"
      assert result["data-on-stage-change-client"] == "stage_client"
    end
  end
end
