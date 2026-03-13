defmodule Corex.AngleSliderTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

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

  describe "angle_slider/1 direct rendering" do
    test "renders with all attributes and markers" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.AngleSlider.angle_slider
              id="test-slider-full"
              value={45}
              name="angle"
              step={15}
              controlled={true}
              disabled={true}
              invalid={true}
              read_only={true}
              dir="rtl"
              on_value_change="change"
              on_value_change_end="change_end"
              on_value_change_client="change_client"
              on_value_change_end_client="change_end_client"
              marker_values={[0, 90, 180]}
            >
              <:label>Angle</:label>
            </Corex.AngleSlider.angle_slider>
            """
          end,
          %{}
        )

      assert html =~ "Angle"
      assert html =~ "45"
      assert html =~ "data-disabled"
      assert html =~ "data-invalid"
      assert html =~ "data-step=\"15\""
      assert html =~ "data-part=\"marker-group\""
      assert html =~ "data-part=\"marker\""
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
