defmodule E2eWeb.StylePageExpectations do
  @moduledoc false

  alias Corex.Design.ComponentLayout

  @style_pages [
    {"accordion/accordion_styling_page.html.heex", "accordion"},
    {"action_styling_page.html.heex", "button"},
    {"angle_slider_styling_page.html.heex", "angle-slider"},
    {"avatar_styling_page.html.heex", "avatar"},
    {"carousel_styling_page.html.heex", "carousel"},
    {"checkbox_styling_page.html.heex", "checkbox"},
    {"clipboard_styling_page.html.heex", "clipboard"},
    {"code_styling_page.html.heex", "code"},
    {"collapsible_styling_page.html.heex", "collapsible"},
    {"color_picker_styling_page.html.heex", "color-picker"},
    {"combobox_styling_page.html.heex", "combobox"},
    {"data_list_styling_page.html.heex", "data-list"},
    {"date_picker_styling_page.html.heex", "date-picker"},
    {"dialog_styling_page.html.heex", "dialog"},
    {"editable_styling_page.html.heex", "editable"},
    {"file_upload_styling_page.html.heex", "file-upload"},
    {"floating_panel_styling_page.html.heex", "floating-panel"},
    {"layout_heading_styling_page.html.heex", "layout-heading"},
    {"listbox_styling_page.html.heex", "listbox"},
    {"marquee_styling_page.html.heex", "marquee"},
    {"menu_styling_page.html.heex", "menu"},
    {"native_input_styling_page.html.heex", "native-input"},
    {"navigate_styling_page.html.heex", "link"},
    {"number_input_styling_page.html.heex", "number-input"},
    {"pagination_styling_page.html.heex", "pagination"},
    {"password_input_styling_page.html.heex", "password-input"},
    {"pin_input_styling_page.html.heex", "pin-input"},
    {"radio_group_styling_page.html.heex", "radio-group"},
    {"select_styling_page.html.heex", "select"},
    {"signature_styling_page.html.heex", "signature-pad"},
    {"switch_styling_page.html.heex", "switch"},
    {"tabs_styling_page.html.heex", "tabs"},
    {"tags_input_styling_page.html.heex", "tags-input"},
    {"timer_styling_page.html.heex", "timer"},
    {"toggle_styling_page.html.heex", "toggle"},
    {"toggle_group_styling_page.html.heex", "toggle-group"},
    {"tooltip_styling_page.html.heex", "tooltip"},
    {"tree_view/tree_view_styling_page.html.heex", "tree-view"}
  ]

  @skip_sizing ~W(avatar menu dialog tooltip link angle-slider floating-panel)
  @skip_max_width_only ~W(pin-input)

  @fit_max_width_block_demo ~W(button switch toggle timer clipboard color-picker date-picker)

  @block_demo_modules %{
    "button" => "action_demo.ex",
    "switch" => "switch_demo.ex",
    "toggle" => "toggle_demo.ex",
    "timer" => "timer_demo.ex",
    "clipboard" => "clipboard_demo.ex",
    "color-picker" => "color_picker_demo.ex",
    "date-picker" => "date_picker_demo.ex"
  }

  def style_pages, do: @style_pages

  def fit_max_width_block_demo_layout_ids, do: @fit_max_width_block_demo

  def block_max_width_demo?(layout_id), do: layout_id in @fit_max_width_block_demo

  def layout_id_for_page(relative_path) do
    case Enum.find(@style_pages, fn {path, _} -> path == relative_path end) do
      {_, layout_id} -> layout_id
      nil -> nil
    end
  end

  def sizing_expectations(layout_id) when layout_id in @skip_sizing do
    %{width: false, max_width: false}
  end

  def sizing_expectations(layout_id) when layout_id in @skip_max_width_only do
    %{width: true, max_width: false}
  end

  def sizing_expectations(layout_id) do
    case ComponentLayout.host_width(layout_id) do
      :fit -> %{width: true, max_width: true}
      _ -> %{width: false, max_width: true}
    end
  end

  def page_html_root do
    Path.expand("lib/e2e_web/controllers/page_html", File.cwd!())
  end

  def demos_root do
    Path.expand("lib/e2e_web/demos", File.cwd!())
  end

  def read_page(relative_path) do
    Path.join(page_html_root(), relative_path)
    |> File.read!()
  end

  def read_block_demo_module(layout_id) do
    @block_demo_modules
    |> Map.fetch!(layout_id)
    |> then(&Path.join(demos_root(), &1))
    |> File.read!()
  end

  def data_table_style_live_path do
    Path.expand("lib/e2e_web/live/pages_live/data_table_style_live.ex", File.cwd!())
  end

  def read_data_table_style_live do
    data_table_style_live_path()
    |> File.read!()
  end
end
