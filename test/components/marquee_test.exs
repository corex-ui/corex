defmodule Corex.MarqueeTest do
  use ExUnit.Case, async: true

  alias Corex.Marquee
  alias Corex.Marquee.Connect

  describe "pause/1" do
    test "returns JS command" do
      js = Marquee.pause("my-marquee")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "resume/1" do
    test "returns JS command" do
      js = Marquee.resume("my-marquee")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "toggle_pause/1" do
    test "returns JS command" do
      js = Marquee.toggle_pause("my-marquee")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "pause/2" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Marquee.pause(socket, "my-marquee")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "resume/2" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Marquee.resume(socket, "my-marquee")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "toggle_pause/2" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Marquee.toggle_pause(socket, "my-marquee")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{
        id: "test-marquee",
        dir: "ltr",
        orientation: "horizontal",
        duration: 10,
        spacing: "1rem",
        delay: 0,
        loop_count: 0,
        translate: "0px",
        respect_reduced_motion: true
      }

      result = Connect.root(assigns)
      assert result["id"] == "marquee:test-marquee"
      assert result["data-scope"] == "marquee"
      assert result["data-part"] == "root"
      assert result["role"] == "region"
      assert result["aria-roledescription"] == "marquee"
    end

    test "includes aria-label from assigns" do
      assigns = %{
        id: "test-marquee",
        aria_label: "Logos carousel",
        dir: "ltr",
        orientation: "horizontal",
        duration: 10,
        spacing: "1rem",
        delay: 0,
        loop_count: 0,
        translate: "0px",
        respect_reduced_motion: true
      }

      result = Connect.root(assigns)
      assert result["aria-label"] == "Logos carousel"
    end

    test "defaults aria-label when omitted" do
      assigns = %{
        id: "test-marquee",
        dir: "ltr",
        orientation: "horizontal",
        duration: 10,
        spacing: "1rem",
        delay: 0,
        loop_count: 0,
        translate: "0px",
        respect_reduced_motion: true
      }

      result = Connect.root(assigns)
      assert result["aria-label"] == "Marquee: test-marquee"
    end
  end

  describe "Connect.viewport/1" do
    test "returns viewport attributes" do
      assigns = %{id: "test-marquee", orientation: "horizontal", side: "end"}
      result = Connect.viewport(assigns)
      assert result["id"] == "marquee:test-marquee:viewport"
      assert result["data-scope"] == "marquee"
      assert result["data-part"] == "viewport"
    end
  end

  describe "Connect.edge/1" do
    test "returns edge attributes for end side" do
      assigns = %{side: "end", orientation: "horizontal"}
      result = Connect.edge(assigns)
      assert result["data-part"] == "edge"
      assert result["data-side"] == "end"
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes" do
      assigns = %{orientation: "horizontal"}
      result = Connect.item(assigns)
      assert result["data-scope"] == "marquee"
      assert result["data-part"] == "item"
    end
  end

  describe "Connect.content/1" do
    test "returns content attributes" do
      assigns = %{
        root_id: "test-marquee",
        index: 0,
        orientation: "horizontal",
        side: "end",
        clone: false,
        reverse: false
      }

      result = Connect.content(assigns)
      assert result["id"] == "marquee:test-marquee:content:0"
      assert result["data-part"] == "content"
    end
  end
end
