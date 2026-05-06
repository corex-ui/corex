defmodule Corex.TimerTest do
  use CorexTest.ComponentCase, async: true

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
end
