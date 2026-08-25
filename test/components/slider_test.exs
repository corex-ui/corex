defmodule Corex.SliderTest do
  use CorexTest.ComponentCase, async: true
  import Phoenix.Component

  alias Corex.Slider
  alias Corex.Slider.Anatomy.Props
  alias Corex.Slider.Connect

  describe "slider/1" do
    test "renders a single thumb" do
      html =
        render_component(&Slider.slider/1,
          id: "test-slider",
          value: 30,
          name: "volume"
        )

      assert html =~ ~r/data-scope="slider"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/data-part="control"/
      assert html =~ ~r/data-part="track"/
      assert html =~ ~r/data-part="range"/
      assert html =~ ~r/data-part="thumb"/
      assert html =~ ~S(role="slider")
      assert html =~ ~r/data-part="hidden-input"/
      assert html =~ ~r/data-part="value-text"/
      assert html =~ ~S(data-default-value="[30)
      refute html =~ ~r/\bdata-value="/
    end

    test "renders two thumbs for a range value" do
      html =
        render_component(&Slider.slider/1,
          id: "test-range",
          value: [20, 80],
          name: "price"
        )

      assert html =~ ~S(data-index="0")
      assert html =~ ~S(data-index="1")
      assert html =~ ~S(data-submit-name="price[]")
      assert html =~ "20 – 80"
    end
  end

  describe "slider_skeleton/1" do
    test "renders static parts" do
      html = render_component(&Slider.slider_skeleton/1, [])
      assert html =~ ~r/data-scope="slider"/
      assert html =~ ~r/data-part="root"/
      assert html =~ ~r/data-part="track"/
      assert html =~ ~r/data-part="marker-group"/
      assert html =~ ~r/data-loading/
    end
  end

  describe "set_value/2" do
    test "returns JS command" do
      js = Slider.set_value("my-slider", 45)
      assert %Phoenix.LiveView.JS{} = js
      ops = Map.get(js, :ops, [])

      assert Enum.any?(ops, fn
               ["dispatch", %{event: "corex:slider:set-value"}] -> true
               _ -> false
             end)
    end

    test "wraps a number as a list in the payload" do
      js = Slider.set_value("my-slider", 45)
      ops = Map.get(js, :ops, [])

      assert Enum.any?(ops, fn
               ["dispatch", %{detail: %{value: [45]}}] -> true
               _ -> false
             end)
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = Slider.set_value(socket, "my-slider", [20, 80])
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "set_thumb_value/3" do
    test "returns JS command" do
      js = Slider.set_thumb_value("my-slider", 1, 75)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "increment/1 and decrement/1" do
    test "return JS commands" do
      assert %Phoenix.LiveView.JS{} = Slider.increment("my-slider")
      assert %Phoenix.LiveView.JS{} = Slider.decrement("my-slider", 1)
    end
  end

  describe "value/1" do
    test "returns JS command" do
      js = Slider.value("my-slider")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "value/2" do
    test "pushes slider_value event with id" do
      socket = %Phoenix.LiveView.Socket{}
      result = Slider.value(socket, "my-slider")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "slider/1 direct rendering" do
    test "hides markers by default" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Slider.slider id="test-slider-plain" class="slider" value={45}>
              <:label>Volume</:label>
            </Corex.Slider.slider>
            """
          end,
          %{}
        )

      refute html =~ ~S(data-part="marker-group")
    end

    test "renders with all attributes and markers" do
      html =
        render_component(
          fn assigns ->
            _ = assigns

            ~H"""
            <Corex.Slider.slider
              id="test-slider-full"
              value={45}
              name="volume"
              step={5}
              disabled={true}
              invalid={true}
              read_only={true}
              dir="rtl"
              on_value_change="change"
              on_value_change_end="change_end"
              on_value_change_client="change_client"
              on_value_change_end_client="change_end_client"
              markers
              marker_values={[0, 25, 50]}
            >
              <:label>Volume</:label>
            </Corex.Slider.slider>
            """
          end,
          %{}
        )

      assert html =~ "Volume"
      assert html =~ "45"
      assert html =~ "data-disabled"
      assert html =~ "data-invalid"
      assert html =~ "data-step=\"5\""
      assert html =~ "data-part=\"marker-group\""
      assert html =~ "data-part=\"marker\""

      doc =
        case Floki.parse_document(html) do
          {:ok, parsed} -> parsed
          {:error, reason} -> flunk("failed to parse slider HTML: #{inspect(reason)}")
        end

      assert Floki.find(doc, ~S([data-part="control"] [data-part="marker-group"])) == []
      assert [_] = Floki.find(doc, ~S([data-part="root"] > [data-part="marker-group"]))
    end
  end

  describe "Connect.root/1" do
    test "returns root attributes" do
      result =
        Connect.root(%{
          id: "test-slider",
          dir: "ltr",
          value: [0],
          min: 0,
          max: 100,
          origin: "start",
          disabled: false,
          invalid: false,
          read_only: false
        })

      assert result["id"] == "slider:test-slider"
      assert result["data-scope"] == "slider"
      assert result["data-part"] == "root"
    end

    test "computes range offsets for a single thumb" do
      result =
        Connect.root(%{
          id: "test-slider",
          dir: "ltr",
          value: 30,
          min: 0,
          max: 100,
          origin: "start",
          disabled: false,
          invalid: false,
          read_only: false
        })

      assert result["style"] =~ "--slider-range-start:0%"
      assert result["style"] =~ "--slider-range-end:70%"
      assert result["style"] =~ "--slider-thumb-offset-0:calc(30%"
    end

    test "uses plain percent offsets for center alignment" do
      result =
        Connect.root(%{
          id: "test-slider",
          dir: "ltr",
          value: 30,
          min: 0,
          max: 100,
          origin: "start",
          thumb_alignment: "center",
          disabled: false,
          invalid: false,
          read_only: false
        })

      assert result["style"] =~ "--slider-thumb-offset-0:30%"
    end

    test "computes range offsets for two thumbs" do
      {start_off, end_off} = Connect.range_offsets([20, 80], 0, 100, "start")
      assert start_off == "20%"
      assert end_off == "20%"
    end
  end

  describe "Connect.label/1" do
    test "returns label attributes" do
      result =
        Connect.label(%{
          id: "test-slider",
          dir: "ltr",
          disabled: false,
          invalid: false,
          read_only: false
        })

      assert result["id"] == "slider:test-slider:label"
      assert result["data-part"] == "label"
      assert result["for"] == "slider:test-slider:input:0"
    end
  end

  describe "Connect.props/1" do
    test "maps flags and step to default value dataset" do
      m =
        Connect.props(%Props{
          id: "s",
          step: 5,
          disabled: true,
          read_only: true,
          invalid: true,
          value: [30],
          min: 0,
          max: 100,
          on_value_change: "a",
          submit_name: "volume"
        })

      assert m["data-step"] == "5"
      assert m["data-disabled"] == ""
      assert m["data-readonly"] == ""
      assert m["data-invalid"] == ""
      assert m["data-range"] == nil
      assert m["data-default-value"] == "[30]"
      assert m["data-value"] == nil
      assert m["data-on-value-change"] == "a"
      assert m["data-orientation"] == "horizontal"
      assert m["data-submit-name"] == "volume"
    end

    test "sets data-range for multi-thumb values" do
      m =
        Connect.props(%Props{
          id: "s",
          value: [20, 80],
          min: 0,
          max: 100
        })

      assert m["data-range"] == ""
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
      assert c["id"] == "slider:x:control"

      t = Connect.thumb(Map.put(base, :index, 0))
      assert t["data-part"] == "thumb"
      assert t["id"] == "slider:x:thumb:0"
      assert t["data-index"] == "0"
    end
  end

  describe "Connect.hidden_input/1" do
    test "returns hidden input attributes" do
      m =
        Connect.hidden_input(%{
          id: "x",
          name: "volume",
          value: 45,
          index: 0,
          disabled: false,
          dir: "ltr",
          orientation: "horizontal"
        })

      assert m["type"] == "hidden"
      assert m["name"] == "volume"
      assert m["value"] == "45"
      assert m["id"] == "slider:x:input:0"
    end
  end

  describe "Connect.value_text/1 and Connect.marker_group/1" do
    test "returns value_text and marker_group" do
      vt = Connect.value_text(%{id: "x", dir: "ltr", value: [0], orientation: "horizontal"})
      assert vt["data-part"] == "value-text"

      mg = Connect.marker_group(%{id: "x", dir: "ltr", orientation: "horizontal"})
      assert mg["data-part"] == "marker-group"
      assert mg["id"] == "slider:x:marker-group"
    end
  end

  describe "Connect.value/1" do
    test "returns value part" do
      assert Connect.value(%{})["data-part"] == "value"
    end
  end

  describe "slider/1 form field" do
    test "renders from form field with errors" do
      form =
        Phoenix.Component.to_form(
          %{"volume" => "45"},
          as: :user,
          errors: [volume: {"invalid", []}]
        )

      html =
        render_component(
          fn assigns ->
            ~H"""
            <Slider.slider field={@form[:volume]} class="slider" auto_invalid={false}>
              <:label>Volume</:label>
              <:error :let={msg}>{msg}</:error>
            </Slider.slider>
            """
          end,
          %{form: form}
        )

      assert html =~ "invalid"
      refute html =~ ~r/\bdata-invalid=""/
    end
  end

  describe "Connect ignore helpers" do
    test "returns JS for all ignore_* functions" do
      base = %{
        id: "ign",
        dir: "ltr",
        orientation: "horizontal",
        origin: "start",
        value: [0],
        min: 0,
        max: 100,
        disabled: false,
        read_only: false,
        invalid: false,
        name: "volume",
        index: 0
      }

      assert %Phoenix.LiveView.JS{} = Connect.ignore_root(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_label(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_hidden_input(Map.put(base, :value, 0))
      assert %Phoenix.LiveView.JS{} = Connect.ignore_control(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_track(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_range(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_thumb(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_value_text(base)
      assert %Phoenix.LiveView.JS{} = Connect.ignore_marker_group(base)

      assert %Phoenix.LiveView.JS{} =
               Connect.ignore_marker(%{
                 id: "ign",
                 value: 0,
                 slider_value: [0],
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
          value: 50,
          slider_value: [50],
          dir: "ltr",
          orientation: "horizontal",
          disabled: false
        })

      assert m["data-state"] == "at-value"
      assert m["data-value"] == "50"
      assert m["style"] =~ "inset-inline-start:calc(50%"
    end

    test "under-value and over-value" do
      u =
        Connect.marker(%{
          id: "x",
          value: 0,
          slider_value: [50],
          dir: "ltr",
          orientation: "horizontal",
          disabled: false
        })

      assert u["data-state"] == "under-value"

      o =
        Connect.marker(%{
          id: "x",
          value: 100,
          slider_value: [50],
          dir: "ltr",
          orientation: "horizontal",
          disabled: false
        })

      assert o["data-state"] == "over-value"
    end

    test "range uses at-value in-between and under/over outside" do
      assert Connect.marker(%{
               id: "x",
               value: 50,
               slider_value: [20, 80],
               dir: "ltr",
               orientation: "horizontal",
               disabled: false
             })["data-state"] == "at-value"

      assert Connect.marker(%{
               id: "x",
               value: 10,
               slider_value: [20, 80],
               dir: "ltr",
               orientation: "horizontal",
               disabled: false
             })["data-state"] == "under-value"

      assert Connect.marker(%{
               id: "x",
               value: 90,
               slider_value: [20, 80],
               dir: "ltr",
               orientation: "horizontal",
               disabled: false
             })["data-state"] == "over-value"
    end
  end
end
