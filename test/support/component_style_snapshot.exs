%{
  accordion:
    {"accordion",
     [:width, :max_width, :height, :max_height, :semantic, :variant, :size, :text, :radius]},
  action:
    {:recipes, "button",
     %{
       "button" => %{
         base: "button",
         axes: [
           :semantic,
           :size,
           :text,
           :radius,
           :variant,
           :shape,
           :width,
           :max_width,
           :height,
           :max_height
         ]
       },
       "link" => %{
         base: "link",
         axes: [
           :semantic,
           :size,
           :text,
           :radius,
           :variant,
           :shape,
           :width,
           :max_width,
           :height,
           :max_height
         ]
       }
     }},
  angle_slider:
    {"angle-slider", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  avatar: {"avatar", [:width, :max_width, :height, :max_height, :size, :radius]},
  badge:
    {"badge", [:width, :max_width, :height, :max_height, :semantic, :size, :shape]},
  blockquote:
    {"blockquote", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  carousel: {"carousel", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  checkbox: {"checkbox", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  clipboard: {"clipboard", [:width, :max_width, :height, :max_height, :size]},
  code: {"code", [:width, :height, :max_height, :size, :text, :max_width]},
  collapsible:
    {"collapsible", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  color_picker:
    {"color-picker", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  combobox: {"combobox", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  data_list: {"data-list", [:width, :max_width, :height, :max_height, :size]},
  data_table:
    {"data-table", [:width, :max_width, :height, :max_height, :size, :semantic, :radius]},
  date_picker:
    {"date-picker", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  dialog:
    {:recipes, "modal",
     %{
       "modal" => %{
         base: "dialog-modal",
         axes: [:semantic, :size, :text, :radius, :width, :max_width, :height, :max_height]
       },
       "side" => %{
         base: "dialog-side",
         axes: [:semantic, :size, :text, :radius, :width, :max_width, :height, :max_height, :side]
       }
     }},
  editable: {"editable", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  file_upload:
    {"file-upload", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  file_upload_live:
    {"file-upload", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  floating_panel:
    {"floating-panel", [:width, :max_width, :height, :max_height, :semantic, :radius]},
  form: {"form", [:width, :max_width, :height, :max_height, :semantic, :gap]},
  h1: {"h1", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  h2: {"h2", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  h3: {"h3", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  h4: {"h4", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  kbd: {"kbd", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  layout_heading:
    {"layout-heading", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :gap]},
  lead: {"lead", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  list: {"list", [:width, :max_width, :height, :max_height, :text, :semantic]},
  listbox: {"listbox", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  marquee: {"marquee", [:width, :max_width, :height, :max_height, :semantic, :size]},
  menu: {"menu", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  native_input:
    {"native-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  navigate:
    {:recipes, "link",
     %{
       "button" => %{
         base: "button",
         axes: [
           :semantic,
           :size,
           :text,
           :radius,
           :variant,
           :shape,
           :width,
           :max_width,
           :height,
           :max_height
         ]
       },
       "link" => %{
         base: "link",
         axes: [
           :semantic,
           :size,
           :text,
           :radius,
           :variant,
           :shape,
           :width,
           :max_width,
           :height,
           :max_height
         ]
       }
     }},
  number_input:
    {"number-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  p: {"p", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  pagination:
    {"pagination", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  password_input:
    {"password-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  pin_input: {"pin-input", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  radio_group:
    {"radio-group", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  select:
    {"select",
     [:width, :max_width, :height, :max_height, :semantic, :variant, :size, :text, :radius]},
  signature_pad:
    {"signature-pad", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  small: {"small", [:width, :max_width, :height, :max_height, :text, :semantic, :weight]},
  switch: {"switch", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  tabs: {"tabs", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
  tags_input:
    {"tags-input", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
  timer: {"timer", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
  toast: {"toast", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  toggle:
    {"toggle",
     [:width, :max_width, :height, :max_height, :semantic, :variant, :size, :text, :radius]},
  toggle_group:
    {"toggle-group", [:width, :max_width, :height, :max_height, :semantic, :size, :radius]},
  tooltip:
    {"tooltip", [:width, :max_width, :height, :max_height, :semantic, :size, :text, :radius]},
  tree_view:
    {:recipes, "treeview",
     %{
       "treeview" => %{
         base: "tree-view",
         axes: [:semantic, :size, :text, :radius, :width, :max_width, :height, :max_height]
       },
       "navigation" => %{
         base: "tree-navigation",
         axes: [:semantic, :size, :text, :radius, :width, :max_width, :height, :max_height]
       }
     }}
}
