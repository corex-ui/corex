defmodule CorexWeb.Accordion do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Accordion
  alias Corex.Content
  alias Corex.Heroicon

  capture variants: [
            with_custom_slots: %{
              class: "accordion",
              value: ["lorem"],
              items:
                Content.new([
                  %{
                    value: "lorem",
                    label: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
                    meta: %{
                      indicator: "hero-arrow-long-right",
                      icon: "hero-chat-bubble-left-right"
                    }
                  },
                  %{
                    label: "Duis dictum gravida ?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus.",
                    meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
                  },
                  %{
                    value: "donec",
                    label: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
                    meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
                  }
                ]),
              trigger: [
                %{
                  let: :item,
                  inner_block: ~S(<.heroicon name={item.meta.icon} />{item.label})
                }
              ],
              content: [%{let: :item, inner_block: "{item.content}"}],
              indicator: [
                %{let: :item, inner_block: ~S(<.heroicon name={item.meta.indicator} />)}
              ]
            },
            basic: %{
              class: "accordion",
              items:
                Content.new([
                  %{
                    label: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  },
                  %{
                    label: "Duis dictum gravida odio ac pharetra?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  },
                  %{
                    label: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  }
                ]),
              trigger: [%{let: :item, inner_block: "{item.label}"}],
              content: [%{let: :item, inner_block: "{item.content}"}],
              indicator: []
            },
            with_indicator: %{
              class: "accordion",
              items:
                Content.new([
                  %{
                    label: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  },
                  %{
                    label: "Duis dictum gravida ?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  },
                  %{
                    label: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  }
                ]),
              trigger: [%{let: :item, inner_block: "{item.label}"}],
              content: [%{let: :item, inner_block: "{item.content}"}],
              indicator: [%{inner_block: ~S(<.heroicon name="hero-chevron-right" />)}]
            },
            with_switching_indicator: %{
              class: "accordion",
              items:
                Content.new([
                  %{
                    label: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  },
                  %{
                    label: "Duis dictum gravida ?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  },
                  %{
                    label: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  }
                ]),
              trigger: [%{let: :item, inner_block: "{item.label}"}],
              content: [%{let: :item, inner_block: "{item.content}"}],
              indicator: [
                %{
                  inner_block:
                    ~S(<.heroicon name="hero-plus" class="state-closed" /><.heroicon name="hero-minus" class="state-open" />)
                }
              ]
            },
            with_value: %{
              class: "accordion",
              value: ["lorem", "donec"],
              items:
                Content.new([
                  %{
                    value: "lorem",
                    label: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
                  },
                  %{
                    value: "duis",
                    label: "Duis dictum gravida odio ac pharetra?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  },
                  %{
                    value: "donec",
                    label: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  }
                ]),
              trigger: [%{let: :item, inner_block: "{item.label}"}],
              content: [%{let: :item, inner_block: "{item.content}"}],
              indicator: []
            },
            with_disabled: %{
              class: "accordion",
              value: ["lorem"],
              items:
                Content.new([
                  %{
                    value: "lorem",
                    label: "Lorem ipsum dolor sit amet",
                    content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
                    disabled: true
                  },
                  %{
                    value: "duis",
                    label: "Duis dictum gravida odio ac pharetra?",
                    content: "Nullam eget vestibulum ligula, at interdum tellus."
                  },
                  %{
                    value: "donec",
                    label: "Donec condimentum ex mi",
                    content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
                  }
                ]),
              trigger: [%{let: :item, inner_block: "{item.label}"}],
              content: [%{let: :item, inner_block: "{item.content}"}],
              indicator: []
            }
          ]

  defdelegate accordion(assigns), to: Accordion
  defdelegate heroicon(assigns), to: Heroicon
end
