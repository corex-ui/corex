defmodule Corex.FloatingPanelTest do
  use ExUnit.Case, async: true

  alias Corex.FloatingPanel.Connect

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-panel", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "floating-panel:test-panel"
      assert result["data-scope"] == "floating-panel"
      assert result["data-part"] == "root"
    end
  end

  describe "Connect.trigger/1" do
    test "returns trigger attributes when closed" do
      assigns = %{id: "test-panel", initial_open: false}
      result = Connect.trigger(assigns)
      assert result["id"] == "floating-panel:test-panel:trigger"
      assert result["data-state"] == "closed"
    end

    test "returns trigger attributes when open" do
      assigns = %{id: "test-panel", initial_open: true}
      result = Connect.trigger(assigns)
      assert result["data-state"] == "open"
    end
  end
end
