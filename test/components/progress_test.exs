defmodule Corex.ProgressTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Progress, only: [progress: 1]

  test "renders host" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.progress id="progress-unit" class="progress" />
          """
        end,
        %{}
      )

    assert html =~ ~S(phx-hook="Progress")
    assert html =~ ~S(data-scope="progress")
  end

  test "stamps --percent on determinate range and root" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.progress id="progress-percent" class="progress" value={40} />
          """
        end,
        %{}
      )

    assert html =~ "--percent: 40.0"
    assert html =~ "width: 40.0%"
    refute html =~ ~S(data-indeterminate)
  end

  test "loading value is indeterminate without percent" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.progress id="progress-loading" class="progress" value={nil} />
          """
        end,
        %{}
      )

    assert html =~ ~S(data-indeterminate)
    assert html =~ ~S(data-state="indeterminate")
    refute html =~ "--percent:"
  end

  test "circular stamps viewBox and circle geometry" do
    html =
      render_component(
        fn assigns ->
          ~H"""
          <.progress id="progress-circle" class="progress" variant="circular" value={50} />
          """
        end,
        %{}
      )

    assert html =~ ~S(viewBox="0 0 44 44")
    assert html =~ ~S(cx="22")
    assert html =~ ~S(r="20")
    assert html =~ "--circumference"
    assert html =~ "--offset"
  end
end
