defmodule E2eWeb.ColorPickerTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

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
  end

  describe "api" do
    feature "set value (binding)  -  Set red updates swatch", %{session: session} do
      section = "color-picker-api-set-value-c"

      session
      |> ComponentBehaviorSpec.visit_ready(ColorPicker, :color_picker, :api)
      |> ColorPicker.wait_section_color_picker_ready(section)
      |> ColorPicker.click_button_in_section(section, "Set red")
      |> ColorPicker.wait_for_has(
        css("#color-picker-api-value-c [data-part='trigger']", visible: :any),
        timeout: 8_000
      )
    end

    feature "set value (server)  -  Set red via LiveView", %{session: session} do
      section = "color-picker-api-set-value-s"

      session
      |> ComponentBehaviorSpec.visit_ready(ColorPicker, :color_picker, :api)
      |> ColorPicker.prepare_live_form()
      |> ColorPicker.wait_section_color_picker_ready(section)
      |> ColorPicker.click_button_in_section(section, "Set red")
      |> ColorPicker.wait_for_has(
        css("#color-picker-api-value-s [data-part='trigger']", visible: :any),
        timeout: 8_000
      )
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
