defmodule E2eWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use E2eWeb, :html

  embed_templates "page_html/*"

  def menu_items(locale) do
    Corex.Tree.new([
      [
        label: "Accordion",
        id: "accordion",
        children: [
          [label: "Controller", id: "/#{locale}/accordion"],
          [label: "Live", id: "/#{locale}/live/accordion"],
          [label: "Playground", id: "/#{locale}/playground/accordion"],
          [label: "Controlled", id: "/#{locale}/controlled/accordion"],
          [label: "Async", id: "/#{locale}/async/accordion"]
        ]
      ],
      [
        label: "Checkbox",
        id: "checkbox",
        children: [
          [label: "Controller", id: "/#{locale}/checkbox"],
          [label: "Live", id: "/#{locale}/live/checkbox"]
        ]
      ],
      [
        label: "Clipboard",
        id: "clipboard",
        children: [
          [label: "Controller", id: "/#{locale}/clipboard"],
          [label: "Live", id: "/#{locale}/live/clipboard"]
        ]
      ],
      [
        label: "Collapsible",
        id: "collapsible",
        children: [
          [label: "Controller", id: "/#{locale}/collapsible"],
          [label: "Live", id: "/#{locale}/live/collapsible"]
        ]
      ],
      [
        label: "Combobox",
        id: "combobox",
        children: [
          [label: "Controller", id: "/#{locale}/combobox"],
          [label: "Live", id: "/#{locale}/live/combobox"]
        ]
      ]
    ])
  end
end
