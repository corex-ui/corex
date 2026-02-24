defmodule Corex.ClipboardTest do
  use ExUnit.Case, async: true

  alias Corex.Clipboard
  alias Corex.Clipboard.Connect

  describe "set_value/2" do
    test "returns JS command" do
      js = Clipboard.set_value("my-clipboard", "hello")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Clipboard.set_value(socket, "my-clipboard", "world")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{id: "test-clipboard", dir: "ltr"}
      result = Connect.root(assigns)
      assert result["id"] == "clipboard:test-clipboard"
      assert result["data-scope"] == "clipboard"
    end
  end

  describe "Connect.input/1" do
    test "returns input attributes" do
      assigns = %{id: "test-clipboard", dir: "ltr", value: "copy-me"}
      result = Connect.input(assigns)
      assert result["id"] == "clipboard:test-clipboard:input"
      assert result["value"] == "copy-me"
    end
  end
end
