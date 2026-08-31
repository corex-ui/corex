defmodule Corex.DrawerTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Drawer, only: [drawer: 1]

  alias Corex.Drawer.Connect

  describe "drawer/1" do
    test "renders trigger, grabber, and content" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.drawer id="dr-unit">
              <:trigger>Open</:trigger>
              <:content>Sheet</:content>
            </.drawer>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-scope="drawer")
      assert html =~ ~S(data-part="grabber")
      assert html =~ ~S(data-part="backdrop")
      assert html =~ "Open"
      assert html =~ "Sheet"
    end

    test "renders snap point dataset" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.drawer id="dr-snap" snap_points="0.3,1" default_snap_point="0.3">
              <:trigger>Open</:trigger>
              <:content>Sheet</:content>
            </.drawer>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-snap-points="0.3,1")
      assert html =~ ~S(data-default-snap-point="0.3")
    end
  end

  describe "Connect.props/1" do
    test "maps swipe direction" do
      props =
        Connect.props(%Corex.Drawer.Anatomy.Props{
          id: "d",
          swipe_direction: "up"
        })

      assert props["data-swipe-direction"] == "up"
    end
  end

  describe "set_open/2" do
    test "returns JS dispatch" do
      assert %Phoenix.LiveView.JS{} = Corex.Drawer.set_open("dr-unit", true)
    end
  end
end
