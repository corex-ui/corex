defmodule Corex.PopoverTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Popover, only: [popover: 1]

  alias Corex.Popover.Connect

  describe "popover/1" do
    test "renders trigger and content" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.popover id="pop-unit">
              <:trigger>Open</:trigger>
              <:content>Details</:content>
            </.popover>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-scope="popover")
      assert html =~ ~S(id="popover:pop-unit:popper")
      assert html =~ "Open"
      assert html =~ "Details"
      refute html =~ ~S(data-part="arrow")
    end

    test "renders title and close trigger" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.popover id="pop-title">
              <:trigger>Open</:trigger>
              <:title>Title</:title>
              <:content>Body</:content>
              <:close_trigger>X</:close_trigger>
            </.popover>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-part="title")
      assert html =~ ~S(data-part="close-trigger")
      assert html =~ "Title"
    end

    test "raises when multiple triggers omit value" do
      assert_raise ArgumentError, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <.popover id="pop-bad">
              <:trigger>A</:trigger>
              <:trigger>B</:trigger>
              <:content>C</:content>
            </.popover>
            """
          end,
          %{}
        )
      end
    end
  end

  describe "Connect.props/1" do
    test "maps modal and events" do
      props =
        Connect.props(%Corex.Popover.Anatomy.Props{
          id: "p",
          modal: true,
          on_open_change: "opened"
        })

      assert props["id"] == "p"
      assert props["data-modal"] == ""
      assert props["data-on-open-change"] == "opened"
    end
  end

  describe "set_open/2" do
    test "returns JS dispatch" do
      js = Corex.Popover.set_open("pop-unit", true)
      assert %Phoenix.LiveView.JS{} = js
    end
  end
end
