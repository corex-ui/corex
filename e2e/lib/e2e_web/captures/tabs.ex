defmodule CorexWeb.Tabs do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Tabs
  alias Corex.Content

  @items Content.new([
           [
             id: "lorem",
             trigger: "Lorem",
             content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
           ],
           [
             id: "duis",
             trigger: "Duis",
             content: "Nullam eget vestibulum ligula, at interdum tellus."
           ],
           [
             id: "donec",
             trigger: "Donec",
             content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
           ]
         ])

  capture variants: [
            basic: %{
              id: "my-tabs",
              class: "tabs",
              items: @items
            },
            value_lorem: %{
              id: "my-tabs",
              class: "tabs",
              value: "lorem",
              items: @items
            },
            value_duis: %{
              id: "my-tabs",
              class: "tabs",
              value: "duis",
              items: @items
            },
            value_donec: %{
              id: "my-tabs",
              class: "tabs",
              value: "donec",
              items: @items
            },
            with_disabled: %{
              id: "my-tabs",
              class: "tabs",
              value: "lorem",
              items:
                Content.new([
                  [
                    id: "lorem",
                    trigger: "Lorem",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  ],
                  [
                    id: "duis",
                    trigger: "Duis",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  ],
                  [
                    id: "donec",
                    trigger: "Donec",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
                    disabled: true
                  ]
                ])
            }
          ]

  defdelegate tabs(assigns), to: Tabs
end
