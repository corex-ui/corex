defmodule CorexTest.ComponentStyleSnapshot do
  @moduledoc false

  def expected do
    %{
      radio_group: {"radio-group", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      code: {"code", [:width, :height, :max_height, :size, :text, :max_width]},
      switch: {"switch", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      listbox: {"listbox", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      password_input: {"password-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      floating_panel: {"floating-panel", [:width, :max_width, :height, :max_height, :semantic, :radius]},
      lead: {"lead", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      form: {"form", [:width, :max_width, :height, :max_height, :semantic, :gap]},
      badge: {"badge", [:width, :max_width, :height, :max_height, :semantic, :size, :shape]},
      color_picker: {"color-picker", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      angle_slider: {"angle-slider", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      toggle_group: {"toggle-group", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      action:
        {:recipes, "button",
         %{
           "button" => %{
             base: "button",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius,
               :variant,
               :shape
             ]
           },
           "link" => %{
             base: "link",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius,
               :variant,
               :shape
             ]
           }
         }},
      navigate:
        {:recipes, "link",
         %{
           "button" => %{
             base: "button",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius,
               :variant,
               :shape
             ]
           },
           "link" => %{
             base: "link",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius,
               :variant,
               :shape
             ]
           }
         }},
      list: {"list", [:width, :max_width, :height, :max_height, :text, :semantic]},
      number_input: {"number-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      carousel: {"carousel", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      p: {"p", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      file_upload: {"file-upload", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      h3: {"h3", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      file_upload_live: {"file-upload", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      timer: {"timer", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
      select:
        {"select",
         [:width, :max_width, :height, :max_height, :semantic, :variant, :size, :text, :radius]},
      data_table: {"data-table", [:width, :max_width, :height, :max_height, :size, :semantic, :radius]},
      signature_pad: {"signature-pad", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      h1: {"h1", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      kbd: {"kbd", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      menu: {"menu", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      accordion:
        {"accordion",
         [:width, :max_width, :height, :max_height, :semantic, :variant, :size, :text, :radius]},
      editable: {"editable", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      avatar: {"avatar", [:width, :max_width, :height, :max_height, :size, :radius]},
      blockquote: {"blockquote", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      checkbox: {"checkbox", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      clipboard: {"clipboard", [:width, :max_width, :height, :max_height, :size]},
      dialog:
        {:recipes, "modal",
         %{
           "modal" => %{
             base: "dialog-modal",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius,
               :side
             ]
           },
           "side" => %{
             base: "dialog-side",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius,
               :side
             ]
           }
         }},
      collapsible: {"collapsible", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      tooltip: {"tooltip", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
      combobox: {"combobox", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      native_input: {"native-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      tags_input: {"tags-input", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
      tree_view:
        {:recipes, "treeview",
         %{
           "navigation" => %{
             base: "tree-navigation",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius
             ]
           },
           "treeview" => %{
             base: "tree-view",
             axes: [
               :width,
               :max_width,
               :height,
               :max_height,
               :semantic,
               :size,
               :text,
               :radius
             ]
           }
         }},
      toast: {"toast", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      tabs: {"tabs", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
      pin_input: {"pin-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      h4: {"h4", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      data_list: {"data-list", [:width, :max_width, :height, :max_height, :size]},
      marquee: {"marquee", [:width, :max_width, :height, :max_height, :semantic, :size]},
      h2: {"h2", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      date_picker: {"date-picker", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      pagination: {"pagination", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
      small: {"small", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
      toggle:
        {"toggle",
         [:width, :max_width, :height, :max_height, :semantic, :variant, :size, :text, :radius, :shape]},
      layout_heading:
        {"layout-heading", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :gap]}
    }
  end
end
