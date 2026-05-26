defmodule E2eWeb.DocPageMatrix do
  @moduledoc false

  @wallaby_pages %{
    accordion: [:anatomy, :api, :events, :patterns],
    action: [:anatomy, :style],
    angle_slider: [:anatomy, :api, :events, :patterns],
    avatar: [:anatomy, :api, :events],
    carousel: [:anatomy, :api, :events],
    checkbox: [:anatomy, :api, :events, :patterns],
    clipboard: [:anatomy, :api, :events],
    code: [:anatomy, :style],
    collapsible: [:anatomy, :api, :events, :patterns],
    color_picker: [:anatomy, :api, :events],
    combobox: [:anatomy, :api, :events, :patterns],
    data_list: [:anatomy, :style, :patterns, :playground],
    data_table: [:anatomy, :style, :patterns, :playground],
    date_picker: [:anatomy, :api, :events, :patterns],
    dialog: [:anatomy, :api, :events, :patterns],
    editable: [:anatomy, :api, :events],
    file_upload: [:anatomy, :api, :events],
    file_upload_live: [:anatomy, :form, :playground],
    floating_panel: [:anatomy, :api, :events],
    layout_heading: [:anatomy, :style],
    listbox: [:anatomy, :api, :events, :patterns],
    marquee: [:anatomy, :api, :events],
    menu: [:anatomy, :api, :events, :patterns],
    native_input: [:anatomy, :playground, :style, :form, :live_form],
    navigate: [:anatomy, :style],
    number_input: [:anatomy, :api, :events],
    pagination: [:anatomy, :api, :events, :patterns],
    password_input: [:anatomy, :api, :events],
    pin_input: [:anatomy, :style, :api, :events],
    radio_group: [:anatomy, :api, :events, :patterns],
    select: [:anatomy, :api, :events, :patterns],
    signature_pad: [:anatomy, :api, :events, :style],
    switch: [:anatomy, :api, :events, :patterns],
    tabs: [:anatomy, :api, :events, :patterns],
    tags_input: [:anatomy, :api, :events, :patterns],
    timer: [:anatomy, :api, :events],
    toast: [:playground, :api, :anatomy],
    toggle: [:anatomy, :api, :events, :patterns],
    toggle_group: [:anatomy, :api, :events, :patterns],
    tooltip: [:anatomy, :api, :events, :patterns],
    tree_view: [:anatomy, :api, :events, :patterns]
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
