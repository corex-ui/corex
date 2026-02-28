defmodule Corex.ColorPickerTest do
  use CorexTest.ComponentCase, async: true

  alias Corex.ColorPicker
  alias Corex.ColorPicker.Connect
  alias Corex.ColorPicker.Initial

  describe "color_picker/1" do
    test "renders" do
      html = render_component(&ColorPicker.color_picker/1, [])
      assert html =~ ~r/data-scope="color-picker"/
      assert html =~ ~r/data-part="root"/
    end
  end

  describe "set_open/2" do
    test "returns JS command when open is true" do
      js = ColorPicker.set_open("my-color-picker", true)
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command when open is false" do
      js = ColorPicker.set_open("my-color-picker", false)
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_open/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = ColorPicker.set_open(socket, "my-color-picker", true)
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "set_value/2" do
    test "returns JS command for hex string" do
      js = ColorPicker.set_value("my-color-picker", "#ff0000")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for rgba string" do
      js = ColorPicker.set_value("my-color-picker", "rgba(255, 0, 0, 1)")
      assert %Phoenix.LiveView.JS{} = js
    end
  end

  describe "set_value/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = ColorPicker.set_value(socket, "my-color-picker", "#00ff00")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "set_format/2" do
    test "returns JS command for rgba format" do
      js = ColorPicker.set_format("my-color-picker", "rgba")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for hex format" do
      js = ColorPicker.set_format("my-color-picker", "hex")
      assert %Phoenix.LiveView.JS{} = js
    end

    test "returns JS command for hsla and hsba formats" do
      assert %Phoenix.LiveView.JS{} = ColorPicker.set_format("my-color-picker", "hsla")
      assert %Phoenix.LiveView.JS{} = ColorPicker.set_format("my-color-picker", "hsba")
    end
  end

  describe "set_format/3" do
    test "pushes event to socket" do
      socket = %Phoenix.LiveView.Socket{}
      result = ColorPicker.set_format(socket, "my-color-picker", "hex")
      assert %Phoenix.LiveView.Socket{} = result
    end
  end

  describe "Initial.parse/1" do
    test "returns empty map for nil" do
      result = Initial.parse(nil)
      assert result.swatch_style == nil
      assert result.value_rgba == nil
      assert result.hex_value == nil
      assert result.alpha_value == nil
      assert result.red_value == nil
      assert result.green_value == nil
      assert result.blue_value == nil
    end

    test "returns empty map for empty string" do
      result = Initial.parse("")
      assert result.swatch_style == nil
      assert result.value_rgba == nil
      assert result.hex_value == nil
    end

    test "hex short format - parses #fff to white" do
      result = Initial.parse("#fff")
      assert result.swatch_style == "#fff"
      assert result.hex_value == "#FFFFFF"
      assert result.alpha_value == "1"
      assert result.red_value == "255"
      assert result.green_value == "255"
      assert result.blue_value == "255"
    end

    test "hex short format - parses #f00 to red" do
      result = Initial.parse("#f00")
      assert result.hex_value == "#FF0000"
      assert result.red_value == "255"
      assert result.green_value == "0"
      assert result.blue_value == "0"
    end

    test "hex short format - parses #abc" do
      result = Initial.parse("#abc")
      assert result.hex_value == "#AABBCC"
      assert result.red_value == "170"
      assert result.green_value == "187"
      assert result.blue_value == "204"
    end

    test "hex 6 format - parses #ff0000 to red" do
      result = Initial.parse("#ff0000")
      assert result.swatch_style == "#ff0000"
      assert result.value_rgba == "rgba(255, 0, 0, 1)"
      assert result.hex_value == "#FF0000"
      assert result.alpha_value == "1"
      assert result.red_value == "255"
      assert result.green_value == "0"
      assert result.blue_value == "0"
    end

    test "hex 6 format - parses #00ff00 to green" do
      result = Initial.parse("#00ff00")
      assert result.hex_value == "#00FF00"
      assert result.red_value == "0"
      assert result.green_value == "255"
      assert result.blue_value == "0"
    end

    test "hex 6 format - parses #0000ff to blue" do
      result = Initial.parse("#0000ff")
      assert result.hex_value == "#0000FF"
      assert result.red_value == "0"
      assert result.green_value == "0"
      assert result.blue_value == "255"
    end

    test "hex 6 format - parses #1909c0 (from doc example)" do
      result = Initial.parse("#1909c0")
      assert result.hex_value == "#1909C0"
      assert result.red_value == "25"
      assert result.green_value == "9"
      assert result.blue_value == "192"
    end

    test "hex 6 format - parses uppercase hex" do
      result = Initial.parse("#FF00FF")
      assert result.hex_value == "#FF00FF"
      assert result.red_value == "255"
      assert result.green_value == "0"
      assert result.blue_value == "255"
    end

    test "hex 8 format - parses hex with alpha" do
      result = Initial.parse("#ff000080")
      assert result.swatch_style == "#ff000080"
      assert result.hex_value == "#FF0000"
      assert result.alpha_value == "0.5"
      assert result.red_value == "255"
      assert result.green_value == "0"
      assert result.blue_value == "0"
    end

    test "hex 8 format - parses full opacity alpha" do
      result = Initial.parse("#1909c0ff")
      assert result.alpha_value == "1"
    end

    test "hex 8 format - parses zero alpha" do
      result = Initial.parse("#00000000")
      assert result.alpha_value == "0.0"
    end

    test "rgb format - parses rgb(r,g,b)" do
      result = Initial.parse("rgb(25, 9, 192)")
      assert result.swatch_style == "rgb(25, 9, 192)"
      assert result.hex_value == "#1909C0"
      assert result.alpha_value == "1"
      assert result.red_value == "25"
      assert result.green_value == "9"
      assert result.blue_value == "192"
    end

    test "rgb format - parses rgb with minimal spaces" do
      result = Initial.parse("rgb(255,0,0)")
      assert result.hex_value == "#FF0000"
      assert result.red_value == "255"
    end

    test "rgb format - clamps values to 0-255" do
      result = Initial.parse("rgb(300, 0, 128)")
      assert result.red_value == "255"
      assert result.green_value == "0"
      assert result.blue_value == "128"
    end

    test "rgb with 4 args - parses rgb(r,g,b,a) as rgba" do
      result = Initial.parse("rgb(25, 9, 192, 0.9)")
      assert result.swatch_style == "rgb(25, 9, 192, 0.9)"
      assert result.hex_value == "#1909C0"
      assert result.alpha_value == "0.9"
      assert result.red_value == "25"
      assert result.green_value == "9"
      assert result.blue_value == "192"
    end

    test "rgba format - parses rgba(r,g,b,a)" do
      result = Initial.parse("rgba(25, 9, 192, 0.9)")
      assert result.swatch_style == "rgba(25, 9, 192, 0.9)"
      assert result.hex_value == "#1909C0"
      assert result.alpha_value == "0.9"
      assert result.red_value == "25"
      assert result.green_value == "9"
      assert result.blue_value == "192"
    end

    test "rgba format - parses rgba with alpha 1" do
      result = Initial.parse("rgba(255, 0, 0, 1)")
      assert result.alpha_value == "1"
    end

    test "rgba format - parses rgba with alpha 0" do
      result = Initial.parse("rgba(0, 0, 0, 0)")
      assert result.alpha_value == "0.0"
    end

    test "rgba format - clamps alpha to 0-1" do
      result = Initial.parse("rgba(0, 0, 0, 1.5)")
      assert result.alpha_value == "1"
    end

    test "rgba format - parses rgba with decimal alpha" do
      result = Initial.parse("rgba(128, 64, 32, 0.75)")
      assert result.alpha_value == "0.75"
    end

    test "fallback - uses raw hex string as swatch_style when hex is invalid length" do
      result = Initial.parse("#ffff")
      assert result.swatch_style == "#ffff"
      assert result.hex_value == nil
    end

    test "fallback - uses raw hsl string as swatch_style (not fully parsed)" do
      result = Initial.parse("hsl(120, 100%, 50%)")
      assert result.swatch_style == "hsl(120, 100%, 50%)"
      assert result.hex_value == nil
    end

    test "fallback - returns nil swatch for invalid format" do
      result = Initial.parse("not-a-color")
      assert result.swatch_style == nil
      assert result.hex_value == nil
    end

    test "trims whitespace" do
      result = Initial.parse("  #ff0000  ")
      assert result.hex_value == "#FF0000"
    end
  end

  describe "Connect.props/1" do
    test "returns base props" do
      assigns = base_assigns()
      result = Connect.props(assigns)
      assert result["id"] == "test-color-picker"
      assert result["data-format"] == "rgba"
    end

    test "returns props with default_value" do
      assigns = base_assigns(default_value: "rgb(25, 9, 192, 0.9)")
      result = Connect.props(assigns)
      assert result["id"] == "test-color-picker"
      assert result["data-default-value"] == "rgb(25, 9, 192, 0.9)"
      assert result["data-format"] == "rgba"
      assert result["data-default-format"] == "rgba"
    end

    test "returns props with hex format" do
      assigns = base_assigns(format: "hex", default_format: "hex", default_value: "#ff0000")
      result = Connect.props(assigns)
      assert result["data-format"] == "hex"
      assert result["data-default-format"] == "hex"
    end

    test "returns props with hsla format" do
      assigns = base_assigns(format: "hsla", default_format: "hsla")
      result = Connect.props(assigns)
      assert result["data-format"] == "hsla"
      assert result["data-default-format"] == "hsla"
    end

    test "returns props with hsba format" do
      assigns = base_assigns(format: "hsba", default_format: "hsba")
      result = Connect.props(assigns)
      assert result["data-format"] == "hsba"
      assert result["data-default-format"] == "hsba"
    end

    test "controlled mode uses value not default_value" do
      assigns =
        base_assigns(
          controlled: true,
          value: "#1909c0",
          default_value: "#ff0000"
        )

      result = Connect.props(assigns)
      assert result["data-value"] == "#1909c0"
      assert result["data-default-value"] == "#ff0000"
    end

    test "controlled mode passes open state" do
      assigns = base_assigns(controlled: true, open: true)
      result = Connect.props(assigns)
      assert result["data-open"] == ""
    end

    test "includes event names when set" do
      assigns =
        base_assigns(
          on_value_change: "update_color",
          on_value_change_end: "commit_color",
          on_open_change: "toggle_picker"
        )

      result = Connect.props(assigns)
      assert result["data-on-value-change"] == "update_color"
      assert result["data-on-value-change-end"] == "commit_color"
      assert result["data-on-open-change"] == "toggle_picker"
    end

    test "includes positioning when set" do
      assigns = base_assigns(positioning: %{placement: "bottom"})
      result = Connect.props(assigns)
      assert result["data-positioning"] =~ "placement"
    end

    test "includes dir" do
      assigns = base_assigns(dir: "rtl")
      result = Connect.props(assigns)
      assert result["data-dir"] == "rtl"
    end

    test "includes boolean attributes" do
      assigns =
        base_assigns(
          disabled: true,
          invalid: true,
          read_only: true,
          required: true,
          close_on_select: false
        )

      result = Connect.props(assigns)
      assert result["data-disabled"] == ""
      assert result["data-invalid"] == ""
      assert result["data-read-only"] == ""
      assert result["data-required"] == ""
      assert result["data-close-on-select"] == nil
    end
  end

  describe "color_picker/1 component" do
    test "assigns initial from default_value" do
      initial = Initial.parse("rgba(25, 9, 192, 0.9)")
      assert initial.hex_value == "#1909C0"
      assert initial.alpha_value == "0.9"
      assert initial.red_value == "25"
      assert initial.green_value == "9"
      assert initial.blue_value == "192"
      assert initial.swatch_style == "rgba(25, 9, 192, 0.9)"
      assert initial.value_rgba == "rgba(25, 9, 192, 0.9)"
    end

    test "assigns initial from controlled value" do
      initial = Initial.parse("rgba(0, 128, 255, 0.5)")
      assert initial.hex_value == "#0080FF"
      assert initial.alpha_value == "0.5"
    end

    test "assigns empty initial when no value" do
      initial = Initial.parse(nil)
      assert initial.hex_value == nil
      assert initial.alpha_value == nil
      assert initial.swatch_style == nil
    end
  end

  defp base_assigns(overrides \\ []) do
    [
      id: "test-color-picker",
      default_value: nil,
      value: nil,
      name: nil,
      format: "rgba",
      default_format: "rgba",
      controlled: false,
      close_on_select: true,
      default_open: false,
      open: false,
      open_auto_focus: true,
      disabled: false,
      invalid: false,
      read_only: false,
      required: false,
      dir: "ltr",
      positioning: %{},
      on_value_change: nil,
      on_value_change_end: nil,
      on_open_change: nil
    ]
    |> Keyword.merge(overrides)
    |> Map.new()
  end
end
