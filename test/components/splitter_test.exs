defmodule Corex.SplitterTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Splitter, only: [splitter: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.splitter id="splitter-unit" class="splitter" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="Splitter")
    assert html =~ ~S(data-scope="splitter")
    assert html =~ ~S(data-part="resize-trigger")
    assert html =~ "Sidebar. Drag the handle"
