defmodule E2eWeb.ComponentStyleDefaults do
  @moduledoc false

  @nil_axes [:semantic, :text, :radius, :shape, :as]

  @base_controls %{
    semantic: nil,
    variant: "subtle",
    size: "md",
    text: nil,
    radius: nil,
    width: "full",
    max_width: "md",
    height: "auto",
    max_height: "none",
    shape: nil,
    as: nil,
    disabled: false
  }

  @component_overrides %{
    action: %{as: "button", variant: "solid", width: nil, max_width: nil, height: nil, max_height: nil},
    accordion: %{variant: "subtle", max_width: "md"},
    angle_slider: %{width: nil, max_width: nil, height: nil, max_height: nil},
    avatar: %{width: nil, max_width: nil, height: nil, max_height: nil},
    carousel: %{width: nil, max_width: nil, height: nil, max_height: nil},
    checkbox: %{max_width: "4xl"},
    clipboard: %{
      semantic: nil,
      variant: nil,
      width: nil,
      max_width: nil,
      height: nil,
      max_height: nil,
      text: nil,
      radius: nil
    },
    code: %{
      semantic: nil,
      variant: nil,
      width: nil,
      height: nil,
      max_height: nil,
      text: nil,
      radius: nil,
      max_width: "md"
    },
    collapsible: %{max_width: "4xl"},
    color_picker: %{max_width: "4xl"},
    combobox: %{max_width: "4xs"},
    data_list: %{variant: nil, text: nil, max_width: "md"},
    date_picker: %{max_width: "4xl"},
    dialog: %{width: "fit", max_width: "none"},
    editable: %{max_width: "4xl"},
    file_upload: %{max_width: "4xl"},
    floating_panel: %{size: nil, text: nil, width: nil, max_width: nil, height: nil, max_height: nil},
    layout_heading: %{
      variant: nil,
      size: nil,
      text: nil,
      radius: nil,
      width: nil,
      height: nil,
      max_height: nil,
      max_width: "md"
    },
    listbox: %{max_width: "4xs"},
    marquee: %{
      semantic: nil,
      variant: nil,
      text: nil,
      radius: nil,
      width: nil,
      height: nil,
      max_height: nil,
      max_width: "md"
    },
    menu: %{max_width: "4xl"},
    native_input: %{max_width: "4xl"},
    navigate: %{
      as: nil,
      variant: nil,
      text: nil,
      radius: nil,
      width: nil,
      max_width: nil,
      height: nil,
      max_height: nil,
      shape: nil,
      disabled: false
    },
    number_input: %{max_width: "4xl"},
    pagination: %{max_width: "md"},
    password_input: %{max_width: "4xl"},
    pin_input: %{max_width: "4xl"},
    radio_group: %{max_width: "4xl"},
    select: %{max_width: "4xs", variant: "ghost"},
    signature_pad: %{
      semantic: nil,
      variant: nil,
      text: nil,
      width: nil,
      height: nil,
      max_height: nil,
      max_width: "md"
    },
    switch: %{max_width: "4xl"},
    tabs: %{max_width: "md"},
    tags_input: %{max_width: "4xs"},
    timer: %{width: nil, max_width: nil, height: nil, max_height: nil},
    toast: %{width: nil, max_width: nil, height: nil, max_height: nil},
    toggle: %{max_width: "4xl"},
    toggle_group: %{max_width: "4xl"},
    tooltip: %{width: nil, max_width: nil, height: nil, max_height: nil, radius: nil},
    tree_view: %{max_width: "md"}
  }

  @snippet_defaults %{
    action: %{as: "button", variant: "solid", size: "md"},
    accordion: %{
      variant: "subtle",
      size: "md",
      width: "full",
      max_width: "md",
      height: "auto",
      max_height: "none"
    }
  }

  def control_defaults(component) do
    @base_controls
    |> Map.merge(Map.get(@component_overrides, component, %{}))
    |> Map.take(axis_keys(component))
  end

  def snippet_defaults(component) do
    Map.get(@snippet_defaults, component, snippet_defaults_for(component))
  end

  def axis_default(component, axis) do
    component
    |> control_defaults()
    |> Map.get(axis)
  end

  defp axis_keys(component) do
    E2eWeb.ComponentStyleConfig.playground_axes(component)
    |> Enum.uniq()
  end

  defp snippet_defaults_for(component) do
    component
    |> control_defaults()
    |> Enum.reject(fn {axis, value} -> axis in @nil_axes or value in [nil, false] end)
    |> Map.new()
  end
end
