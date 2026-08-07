defmodule E2eWeb.ColorPickerTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ColorPickerModel, as: ColorPicker
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :color_picker

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section mounts color picker hook", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, ColorPicker, :color_picker, :anatomy)

      Enum.each(ColorPicker.anatomy_section_ids(), fn section_id ->
        ColorPicker.wait_section_color_picker_ready(session, section_id)
      end)
    end

    feature "positioning  -  trigger click opens content", %{session: session} do
      section = "color-picker-anatomy-positioning"

      session
      |> ComponentBehaviorSpec.visit_ready(ColorPicker, :color_picker, :anatomy)
      |> ColorPicker.wait_section_color_picker_ready(section)
      |> ColorPicker.open_color_picker_in_section(section)

      host_id =
        session
        |> find(
          css(
            ~s|section##{section} [phx-hook="ColorPicker"]|,
            visible: :any
          )
        )
        |> Wallaby.Element.attr("id")

      ColorPicker.assert_content_open(session, host_id, timeout: 8_000)
    end
  end

  describe "api" do
    feature "set value (binding)  -  Set red updates swatch", %{session: session} do
      section = "color-picker-api-set-value-c"
      host_id = "color-picker-api-value-c"

      session
      |> ComponentBehaviorSpec.visit_ready(ColorPicker, :color_picker, :api)
      |> ColorPicker.wait_section_color_picker_ready(section)
      |> ColorPicker.click_button_in_section(section, "Set red")
      |> ColorPicker.wait_value(host_id, "#ff0000", timeout: 8_000)
    end

    feature "set value (server)  -  Set red via LiveView", %{session: session} do
      section = "color-picker-api-set-value-s"
      host_id = "color-picker-api-value-s"

      session
      |> ComponentBehaviorSpec.visit_ready(ColorPicker, :color_picker, :api)
      |> ColorPicker.prepare_live_form()
      |> ColorPicker.wait_section_color_picker_ready(section)
      |> ColorPicker.click_button_in_section(section, "Set red")
      |> ColorPicker.wait_value(host_id, "#ff0000", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  value change appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(ColorPicker, :color_picker, :events)
        |> ColorPicker.prepare_live_form()
        |> ColorPicker.wait_root_color_picker_ready("color-picker-ev-sv")

      refute ColorPicker.color_picker_events_server_value_log_has_row?(session)

      session
      |> ColorPicker.click_preset_by_host_id("color-picker-ev-sv", 0)
      |> ColorPicker.wait_for_has(
        css("#color-picker-events-sv-table tr[data-part='row']", count: 1),
        timeout: 10_000
      )
    end
  end
end
