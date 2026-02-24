defmodule Corex.TimerTest do
  use ExUnit.Case, async: true

  alias Corex.Timer.Connect

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-timer"}
      result = Connect.root(assigns)
      assert result["id"] == "timer:test-timer"
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
