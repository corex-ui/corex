defmodule Corex.MarqueeTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.Marquee
  alias Corex.Marquee.Connect

  describe "marquee/1" do
    test "renders" do
      html = render_component(&CorexTest.ComponentHelpers.render_marquee/1, [])
      assert html =~ ~r/data-scope="marquee"/
      assert html =~ ~r/data-part="root"/
    end
  end

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

  describe "Connect.props/1" do
    test "returns full props with events" do
      assigns = %Corex.Marquee.Anatomy.Props{
        id: "test",
        side: "top",
        duration: 20,
        content_count: 2,
        speed: 10,
        spacing: "20px",
        auto_fill: true,
        pause_on_interaction: true,
        default_paused: true,
        delay: 5,
        loop_count: 3,
        reverse: true,
        respect_reduced_motion: false,
        dir: "ltr",
        aria_label: "L",
        on_pause_change: "pc",
        on_pause_change_client: "pcc",
        on_loop_complete: "lc",
        on_loop_complete_client: "lcc",
        on_complete: "c",
        on_complete_client: "cc"
      }
      
      result = Connect.props(assigns)
      assert result["data-orientation"] == "vertical"
      assert result["data-on-pause-change"] == "pc"
      assert result["data-respect-reduced-motion"] == "false"
      assert result["data-aria-label"] == "L"
      assert result["data-reverse"] == ""
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

    test "respect_reduced_motion false and loop_count > 0" do
      assigns = %{
        id: "test",
        dir: "ltr",
        orientation: "vertical",
        duration: 10,
        spacing: "1rem",
        delay: 0,
        loop_count: 5,
        translate: "0px",
        respect_reduced_motion: false
      }
      result = Connect.root(assigns)
      assert result["data-respect-reduced-motion"] == "false"
      assert result["style"] =~ "flex-direction:column"
      assert result["style"] =~ "--marquee-loop-count:5"
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
      assert result["style"] =~ "flex-direction:row-reverse"

      assigns = %{id: "test-marquee", orientation: "vertical", side: "bottom"}
      result = Connect.viewport(assigns)
      assert result["style"] =~ "flex-direction:column-reverse"

      assigns = %{id: "test-marquee", orientation: "vertical", side: "top"}
      result = Connect.viewport(assigns)
      assert result["style"] =~ "flex-direction:column"

      assigns = %{id: "test-marquee", orientation: "horizontal", side: "start"}
      result = Connect.viewport(assigns)
      assert result["style"] =~ "flex-direction:row"
    end
  end

  describe "Connect.edge/1" do
    test "returns edge attributes for end side" do
      assigns = %{side: "end", orientation: "horizontal"}
      result = Connect.edge(assigns)
      assert result["data-part"] == "edge"
      assert result["data-side"] == "end"
    end

    test "returns edge attributes for other sides" do
      assert Connect.edge(%{side: "start", orientation: "horizontal"})["style"] =~ "inset-inline-start:0"
      assert Connect.edge(%{side: "top", orientation: "vertical"})["style"] =~ "top:0"
      assert Connect.edge(%{side: "bottom", orientation: "vertical"})["style"] =~ "bottom:0"
    end
  end

  describe "Connect.item/1" do
    test "returns item attributes" do
      assigns = %{orientation: "horizontal"}
      result = Connect.item(assigns)
      assert result["data-scope"] == "marquee"
      assert result["data-part"] == "item"
      
      assigns = %{orientation: "vertical"}
      result = Connect.item(assigns)
      assert result["style"] =~ "margin-block"
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

    test "returns content attributes for clone and reverse" do
      assigns = %{
        root_id: "t",
        index: 1,
        orientation: "vertical",
        side: "top",
        clone: true,
        reverse: true
      }
      result = Connect.content(assigns)
      assert result["data-reverse"] == ""
      assert result["role"] == "presentation"
      assert result["aria-hidden"] == "true"
      assert result["style"] =~ "flex-direction:column"
    end
  end
end
