defmodule Corex.AngleSliderTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.AngleSlider
  alias Corex.AngleSlider.Connect

  describe "angle_slider/1" do
    test "renders" do
      html = render_component(&AngleSlider.angle_slider/1, value: 0, name: "angle")
      assert html =~ ~r/data-scope="angle-slider"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = AngleSlider.set_value("my-slider", 45)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = AngleSlider.set_value(socket, "my-slider", 90)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      assigns = %{
        id: "test-slider",
        dir: "ltr",
        value: 0,
        disabled: false,
        invalid: false,
        read_only: false
      }

      result = Connect.root(assigns)
      assert result["id"] == "angle-slider:test-slider"
      assert result["data-scope"] == "angle-slider"
      assert result["data-part"] == "root"
    end

    test "computes root with custom value" do
      assigns = %{
        id: "test-slider",
        dir: "ltr",
        value: 90,
        disabled: false,
        invalid: false,
        read_only: false
      }

      result = Connect.root(assigns)
      assert result["style"] =~ "90deg"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      assigns = %{
        id: "test-slider",
        dir: "ltr",
        disabled: false,
        invalid: false,
        read_only: false
      }

      result = Connect.label(assigns)
      assert result["id"] == "angle-slider:test-slider:label"
      assert result["data-part"] == "label"
    end
  end
end
