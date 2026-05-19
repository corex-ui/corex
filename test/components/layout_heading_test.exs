defmodule Corex.Layout.HeadingTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Layout.Heading, only: [layout_heading: 1]

  describe "layout_heading/1" do
    test "renders title subtitle and actions slots" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.layout_heading>
              <:title>Settings</:title>
              <:subtitle>Manage</:subtitle>
              <:actions><span data-test="act">Save</span></:actions>
            </.layout_heading>
            """
          end,
          %{}
        )

      assert html =~ ~S(data-scope="layout-heading")
      assert html =~ "Settings"
      assert html =~ "Manage"
      assert html =~ ~S(data-test="act")
    end
  end
end
