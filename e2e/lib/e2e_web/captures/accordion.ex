defmodule CorexWeb.Accordion do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Accordion
  alias Corex.Content
  alias E2eWeb.CoreComponents

  capture variants: [
            with_custom_slots: %{
              class: "accordion",
              value: ["lorem"],
              items:
                Content.new([
                  [
                    id: "lorem",
                    trigger: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
                    meta: %{
                      indicator: "hero-arrow-long-right",
                      icon: "hero-chat-bubble-left-right"
                    }
                  ],
                  [
                    trigger: "Duis dictum gravida ?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus.",
                    meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
                  ],
                  [
                    id: "donec",
                    trigger: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
                    meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
                  ]
                ]),
              trigger: [
                %{
                  let: :item,
                  inner_block: ~s(<.icon name={item.data.meta.icon} />{item.data.trigger})
                }
              ],
              content: [%{let: :item, inner_block: "{item.data.content}"}],
              indicator: [
                %{let: :item, inner_block: ~s(<.icon name={item.data.meta.indicator} />)}
              ]
            },
            basic: %{
              class: "accordion",
              items:
                Content.new([
                  [
                    trigger: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  ],
                  [
                    trigger: "Duis dictum gravida odio ac pharetra?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  ],
                  [
                    trigger: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  ]
                ]),
              trigger: [%{let: :item, inner_block: "{item.data.trigger}"}],
              content: [%{let: :item, inner_block: "{item.data.content}"}],
              indicator: []
            },
            with_indicator: %{
              class: "accordion",
              items:
                Content.new([
                  [
                    trigger: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  ],
                  [
                    trigger: "Duis dictum gravida ?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  ],
                  [
                    trigger: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  ]
                ]),
              trigger: [%{let: :item, inner_block: "{item.data.trigger}"}],
              content: [%{let: :item, inner_block: "{item.data.content}"}],
              indicator: [%{inner_block: ~s(<.icon name="hero-chevron-right" />)}]
            },
            with_switching_indicator: %{
              class: "accordion",
              items:
                Content.new([
                  [
                    trigger: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  ],
                  [
                    trigger: "Duis dictum gravida ?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  ],
                  [
                    trigger: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  ]
                ]),
              trigger: [%{let: :item, inner_block: "{item.data.trigger}"}],
              content: [%{let: :item, inner_block: "{item.data.content}"}],
              indicator: [
                %{
                  inner_block:
                    ~s(<.icon name="hero-plus" class="state-closed" /><.icon name="hero-minus" class="state-open" />)
                }
              ]
            },
            with_value: %{
              class: "accordion",
              value: ["lorem", "donec"],
              items:
                Content.new([
                  [
                    id: "lorem",
                    trigger: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  ],
                  [
                    id: "duis",
                    trigger: "Duis dictum gravida odio ac pharetra?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  ],
                  [
                    id: "donec",
                    trigger: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  ]
                ]),
              trigger: [%{let: :item, inner_block: "{item.data.trigger}"}],
              content: [%{let: :item, inner_block: "{item.data.content}"}],
              indicator: []
            },
            with_disabled: %{
              class: "accordion",
              value: ["lorem"],
              items:
                Content.new([
                  [
                    id: "lorem",
                    trigger: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
                    disabled: true
                  ],
                  [
                    id: "duis",
                    trigger: "Duis dictum gravida odio ac pharetra?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  ],
                  [
                    id: "donec",
                    trigger: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  ]
                ]),
              trigger: [%{let: :item, inner_block: "{item.data.trigger}"}],
              content: [%{let: :item, inner_block: "{item.data.content}"}],
              indicator: []
            }
          ]

  defdelegate accordion(assigns), to: Accordion
  defdelegate icon(assigns), to: CoreComponents
end
