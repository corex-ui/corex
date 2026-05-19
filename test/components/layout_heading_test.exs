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

    test "title_tag and subtitle_tag choose heading tags" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.layout_heading title_tag="h2" subtitle_tag="p">
              <:title>Playground</:title>
              <:subtitle>Controls</:subtitle>
            </.layout_heading>
            """
          end,
          %{}
        )

      assert html =~ "<h2"
      assert html =~ "Playground"
      assert html =~ "<p"
      assert html =~ "Controls"
      refute html =~ "<h1"
    end
  end
end
