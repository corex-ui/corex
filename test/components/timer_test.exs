defmodule Corex.TimerTest do
  use CorexTest.ComponentCase, async: true

  import Phoenix.Component
  import Corex.Timer, only: [timer: 1]

  alias Corex.Timer.Connect

  describe "timer/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_timer/1, [])
      assert html =~ ~r/data-scope="timer"/
      assert html =~ ~r/data-part="root"/
      assert html =~ "data-auto-start"
    end

    test "omits auto_start attribute when false" do
      html = render_component(&CorexTest.ComponentHelpers.render_timer_paused/1, [])
      refute html =~ "data-auto-start"
    end

    test "omits separator markup when separator slot is absent" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <.timer id="no-sep" start_ms={60_000}>
            </.timer>
            """
          end,
          %{}
        )

      refute html =~ ~s(data-part="separator")
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-timer"}
      result = Connect.root(assigns)
      assert result["id"] == "timer:test-timer:root"
      assert result["data-scope"] == "timer"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.area/1" do
    test "returns area attributes" do
      assigns = %{id: "test-timer"}
      result = Connect.area(assigns)
      assert result["id"] == "timer:test-timer:area"
    end
  end

  describe "Connect.control/1" do
    test "returns control attributes" do
      assigns = %{id: "test-timer"}
      result = Connect.control(assigns)
      assert result["id"] == "timer:test-timer:control"
    end
  end

  describe "timer_skeleton/1" do
    test "renders skeleton markup" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <Corex.Timer.timer_skeleton id="timer-sk" />
            """
          end,
          %{}
        )

      assert html =~ "timer-skeleton"
      assert html =~ ~s(data-timer-segment)
    end
  end

  describe "segments validation" do
    test "raises when segments is empty" do
      assert_raise ArgumentError, ~r/must not be empty/, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <.timer id="t-empty-seg" start_ms={1000} segments={[]} />
            """
          end,
          %{}
        )
      end
    end

    test "raises for invalid segment atom" do
      assert_raise ArgumentError, ~r/subset of/, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <.timer id="t-bad-seg" start_ms={1000} segments={[:weeks]} />
            """
          end,
          %{}
        )
      end
    end

    test "raises when segments are out of order" do
      assert_raise ArgumentError, ~r/must follow order/, fn ->
        render_component(
          fn assigns ->
            ~H"""
            <.timer id="t-order-seg" start_ms={1000} segments={[:minutes, :hours]} />
            """
          end,
          %{}
        )
      end
    end
  end

  describe "collapse and segments rendering" do
    test "renders with custom segments and collapse_leading_zeros" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.timer
              id="t-segments"
              start_ms={3_661_000}
              countdown
              collapse_leading_zeros
              segments={[:hours, :minutes, :seconds]}
            />
            """
          end,
          %{}
        )

      assert html =~ ~s(data-timer-segment)
      assert html =~ ~s(data-type="hours")
    end

    test "renders countdown with collapse default" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.timer id="t-collapse" start_ms={86_400_000} countdown collapse_leading_zeros={false} />
            """
          end,
          %{}
        )

      assert html =~ ~s(data-scope="timer")
    end
  end
end
