defmodule E2eWeb.DocPageMatrix do
  @moduledoc false

  @wallaby_pages %{
    accordion: [:anatomy, :style, :api, :events, :patterns],
    action: [:anatomy, :style],
    angle_slider: [:anatomy, :style, :api, :events, :patterns],
    avatar: [:anatomy, :style, :api, :events],
    carousel: [:anatomy, :style, :api, :events],
    checkbox: [:anatomy, :style, :api, :events, :patterns],
    clipboard: [:anatomy, :style, :api, :events],
    code: [:anatomy, :style],
    collapsible: [:anatomy, :style, :api, :events, :patterns],
    color_picker: [:anatomy, :style, :api, :events],
    combobox: [:anatomy, :style, :api, :events, :patterns],
    data_list: [:anatomy, :style, :patterns, :playground],
    data_table: [:anatomy, :style, :patterns, :playground],
    date_picker: [:anatomy, :style, :api, :events, :patterns],
    dialog: [:anatomy, :style, :api, :events, :patterns],
    editable: [:anatomy, :style, :api, :events],
    file_upload: [:anatomy, :api, :events, :style],
    file_upload_live: [:anatomy, :form, :playground],
    floating_panel: [:anatomy, :api, :events, :style],
    layout_heading: [:anatomy, :style],
    listbox: [:anatomy, :style, :api, :events, :patterns],
    marquee: [:anatomy, :style, :api, :events],
    menu: [:anatomy, :style, :api, :events, :patterns],
    native_input: [:anatomy, :playground, :style, :form, :live_form],
    navigate: [:anatomy, :style],
    number_input: [:anatomy, :style, :api, :events],
    pagination: [:anatomy, :style, :api, :events, :patterns],
    password_input: [:anatomy, :api, :events, :style],
    pin_input: [:anatomy, :style, :api, :events],
    radio_group: [:anatomy, :style, :api, :events, :patterns],
    select: [:anatomy, :style, :api, :events, :patterns],
    signature_pad: [:anatomy, :api, :events, :style],
    switch: [:anatomy, :style, :api, :events, :patterns],
    tabs: [:anatomy, :style, :api, :events, :patterns],
    tags_input: [:anatomy, :style, :api, :events, :patterns],
    timer: [:anatomy, :style, :api, :events],
    toast: [:playground, :api, :anatomy, :style],
    toggle: [:anatomy, :style, :api, :events, :patterns],
    toggle_group: [:anatomy, :style, :api, :events, :patterns],
    tooltip: [:anatomy, :style, :api, :events, :patterns],
    tree_view: [:anatomy, :style, :api, :events, :patterns]
  }

  @pilots MapSet.new([
            :accordion,
            :angle_slider,
            :avatar,
            :carousel,
            :checkbox,
            :clipboard,
            :collapsible,
            :color_picker,
            :combobox,
            :date_picker,
            :dialog,
            :editable,
            :file_upload,
            :floating_panel,
            :listbox,
            :marquee,
            :menu,
            :number_input,
            :password_input,
            :pin_input,
            :radio_group,
            :select,
            :signature_pad,
            :switch,
            :tabs,
            :tags_input,
            :timer,
            :toggle,
            :toggle_group,
            :tooltip,
            :tree_view
          ])

  def wallaby_pages(component) when is_atom(component) do
    Map.fetch!(@wallaby_pages, component)
  end

  def all_components, do: Map.keys(@wallaby_pages)

  def pilot?(component), do: MapSet.member?(@pilots, component)

  def pilots, do: MapSet.to_list(@pilots)
end
