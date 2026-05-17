defmodule Corex.AngleSliderTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.AngleSlider
  alias Corex.AngleSlider.Anatomy.Props
  alias Corex.AngleSlider.Connect

  describe "angle_slider/1" do
    test "renders" do
      html = render_component(&AngleSlider.angle_slider/1, value: 0, name: "angle")
      assert html =~ ~r/data-scope="angle-slider"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/data-part="control"/
      assert html =~ ~r/data-part="thumb"/
      assert html =~ ~r/data-part="hidden-input"/
      assert html =~ ~r/data-part="value-text"/
    end
  end

  describe "angle_slider_skeleton/1" do
    test "renders static parts" do
      html = render_component(&AngleSlider.angle_slider_skeleton/1, [])
      assert html =~ ~r/data-scope="angle-slider"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/data-part="marker-group"/
      assert html =~ ~r/data-loading/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = AngleSlider.set_value("my-slider", 45)
      assert %Phoenix.LiveView.JS{} = js
      ops = Map.get(js, :ops, [])

      assert Enum.any?(ops, fn
               ["dispatch", %{event: "corex:angle-slider:set-value"}] -> true
               _ -> false
             end)
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = AngleSlider.set_value(socket, "my-slider", 90)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "value/1" do
    test "returns JS command" do
      js = AngleSlider.value("my-slider")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "value/2" do
    test "pushes angle_slider_value event with id" do
      socket = %Phoenix.LiveView.Socket{}
      result = AngleSlider.value(socket, "my-slider")
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
      assert result["for"] == "angle-slider:test-slider:input"
    end
  end

  describe "Connect.props/1" do
    test "maps flags and step" do
      m =
        Connect.props(%Props{
          id: "s",
          step: 15,
          disabled: true,
          read_only: true,
          invalid: true,
          controlled: true,
          value: 30,
          on_value_change: "a"
        })

      assert m["data-step"] == "15"
      assert m["data-disabled"] == ""
      assert m["data-read-only"] == ""
      assert m["data-invalid"] == ""
      assert m["data-controlled"] == ""
      assert m["data-value"] == "30"
      assert m["data-on-value-change"] == "a"
      assert m["data-orientation"] == "horizontal"
    end
  end

  describe "Connect.control/1 and Connect.thumb/1" do
    test "returns control and thumb attributes" do
      base = %{
        id: "x",
        dir: "ltr",
        orientation: "horizontal",
        disabled: false,
        read_only: false,
        invalid: false
      }

      c = Connect.control(base)
      assert c["data-part"] == "control"
      assert c["id"] == "angle-slider:x:control"

      t = Connect.thumb(base)
      assert t["data-part"] == "thumb"
      assert t["id"] == "angle-slider:x:thumb"
    end
  end

  describe "Connect.hidden_input/1" do
    test "returns hidden input attributes" do
      m =
        Connect.hidden_input(%{
          id: "x",
          name: "angle",
          value: 45,
          disabled: false,
          dir: "ltr",
          orientation: "horizontal"
        })

      assert m["type"] == "hidden"
      assert m["name"] == "angle"
      assert m["value"] == "45"
      assert m["id"] == "angle-slider:x:input"
    end
  end

  describe "Connect.value_text/1 and Connect.marker_group/1" do
    test "returns value_text and marker_group" do
      vt = Connect.value_text(%{id: "x", dir: "ltr", value: 0, orientation: "horizontal"})
      assert vt["data-part"] == "value-text"

      mg = Connect.marker_group(%{id: "x", dir: "ltr", orientation: "horizontal"})
      assert mg["data-part"] == "marker-group"
      assert mg["id"] == "angle-slider:x:marker-group"
    end
  end

  describe "Connect.value/1 and Connect.text/1" do
    test "returns value and text parts" do
      assert Connect.value(%{})["data-part"] == "value"
      assert Connect.text(%{})["data-part"] == "text"
    end
  end

  describe "angle_slider/1 form field" do
    test "renders from form field with errors" do
      form =
        Phoenix.Component.to_form(
          %{"angle" => "45"},
          as: :user,
          errors: [angle: {"invalid", []}]
        )

      html =
        render_component(
          fn assigns ->
            ~H"""
            <AngleSlider.angle_slider field={@form[:angle]} class="angle-slider">
              <:label>Angle</:label>
              <:error :let={msg}>{msg}</:error>
            </AngleSlider.angle_slider>
            """
          end,
          %{form: form}
        )

      assert html =~ "invalid"
      assert html =~ "data-invalid"
    end
  end

  describe "Connect ignore helpers" do
    test "returns JS for all ignore_* functions" do
      base = %{
        id: "ign",
        dir: "ltr",
        orientation: "horizontal",
        value: 0,
        disabled: false,
        read_only: false,
        invalid: false,
        name: "angle"
      }

      assert %Phoenix.LiveView.JS{} = Connect.ignore_root(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_label(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_hidden_input(Map.put(base, :value, 0))
      assert %Phoenix.LiveView.JS{} = Connect.ignore_control(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_thumb(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_value_text(Map.put(base, :value, 0))
      assert %Phoenix.LiveView.JS{} = Connect.ignore_marker_group(base)

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_marker(%{
                 id: "ign",
                 value: 0,
                 slider_value: 0,
                 dir: "ltr",
                 orientation: "horizontal",
                 disabled: false
               })
    end
  end

  describe "Connect.format_number/1" do
    test "formats integers and floats" do
      assert Connect.format_number(5) == "5"
      assert Connect.format_number(5.5) == "5.5"
    end
  end

  describe "Connect.marker/1" do
    test "at-value when marker equals slider" do
      m =
        Connect.marker(%{
          id: "x",
          value: 90,
          slider_value: 90,
          dir: "ltr",
          orientation: "horizontal",
          disabled: false
        })

      assert m["data-state"] == "at-value"
      assert m["data-value"] == "90"
    end

    test "under-value and over-value" do
      u =
        Connect.marker(%{
          id: "x",
          value: 0,
          slider_value: 90,
          dir: "ltr",
          orientation: "horizontal",
          disabled: false
        })

      assert u["data-state"] == "under-value"

      o =
        Connect.marker(%{
          id: "x",
          value: 180,
          slider_value: 90,
          dir: "ltr",
          orientation: "horizontal",
          disabled: false
        })

      assert o["data-state"] == "over-value"
    end
  end
end
