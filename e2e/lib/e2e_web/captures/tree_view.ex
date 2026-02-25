defmodule CorexWeb.TreeView do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.TreeView

  @items Corex.Tree.new([
           [
             label: "Form",
             id: "form",
             children: [
               [label: "Checkbox", id: "checkbox"],
               [label: "Combobox", id: "combobox"],
               [label: "Color Picker", id: "color_picker"],
               [label: "Date Picker", id: "date_picker"],
               [label: "Native Input", id: "native_input"],
               [label: "Hidden Input", id: "hidden_input"],
               [label: "Number Input", id: "number_input"],
               [label: "Password Input", id: "password_input"],
               [label: "Pin Input", id: "pin_input"],
               [label: "Radio Group", id: "radio_group"],
               [label: "Select", id: "select"]
             ]
           ],
           [
             label: "Layout",
             id: "layout",
             children: [
               [label: "Accordion", id: "accordion"],
               [label: "Collapsible", id: "collapsible"],
               [label: "Floating Panel", id: "floating_panel"],
               [label: "Tabs", id: "tabs"],
               [label: "Tree View", id: "tree_view"]
             ]
           ],
           [
             label: "Navigation",
             id: "navigation",
             children: [
               [label: "Menu", id: "menu"],
               [label: "Navigate", id: "navigate"]
             ]
           ],
           [
             label: "Display",
             id: "display",
             children: [
               [label: "Action", id: "action"],
               [label: "Avatar", id: "avatar"],
               [label: "Carousel", id: "carousel"],
               [label: "Clipboard", id: "clipboard"],
               [label: "Code", id: "code"],
               [label: "Marquee", id: "marquee"],
               [label: "Timer", id: "timer"]
             ]
           ],
           [
             label: "Feedback",
             id: "feedback",
             children: [
               [label: "Dialog", id: "dialog"],
               [label: "Toast", id: "toast"]
             ]
           ],
           [
             label: "Interaction",
             id: "interaction",
             children: [
               [label: "Angle Slider", id: "angle_slider"],
               [label: "Editable", id: "editable"],
               [label: "Signature Pad", id: "signature_pad"],
               [label: "Switch", id: "switch"],
               [label: "Toggle Group", id: "toggle_group"]
             ]
           ]
         ])

  capture variants: [
            basic: %{
              class: "tree-view",
              items: @items
            }
          ]

  defdelegate tree_view(assigns), to: TreeView
end
