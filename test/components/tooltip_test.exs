defmodule Corex.TooltipTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Tooltip, only: [tooltip: 1]

  alias Corex.Tooltip.Anatomy.Props
  alias Corex.Tooltip.Connect

  describe "tooltip/1" do
    test "renders trigger and content" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-unit">
              <:trigger><span>Hover</span></:trigger>
              <:content><span>Details</span></:content>
            </.tooltip>
            """
          end,
          %{}
        )

      assert html =~ ~s(data-scope="tooltip")
      assert html =~ "Hover"
      assert html =~ "Details"
      assert html =~ ~s(data-part="arrow")
    end

    test "omits arrow when show_arrow is false" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.tooltip id="tip-no-arrow" show_arrow={false}>
              <:trigger>T</:trigger>
              <:content>C</:content>
            </.tooltip>
            """
          end,
          %{}
        )

      refute html =~ ~s(data-part="arrow")
    end
  end

  describe "Connect.props/1" do
    test "maps props to data attributes" do
      m =
        Connect.props(%Props{
          id: "id1",
          controlled: true,
          on_open_change: "evt"
        })

      assert m["id"] == "id1"
      assert m["data-controlled"] == ""
      assert m["data-on-open-change"] == "evt"
    end
  end

  describe "set_open/2 and set_open/3" do
    test "returns JS for client toggle" do
      assert %Phoenix.LiveView.JS{} = Corex.Tooltip.set_open("tip-x", true)
    end

    test "pushes server event on socket" do
      socket = %Phoenix.LiveView.Socket{}
      assert %Phoenix.LiveView.Socket{} = Corex.Tooltip.set_open(socket, "tip-x", false)
    end
  end
end
