defmodule E2eWeb.Captures.Accordion do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Accordion
  alias Corex.Content
  alias E2eWeb.CoreComponents

  capture variants: [
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
                ])
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
              indicator: [%{inner_block: &__MODULE__.indicator/2}]
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
              indicator: [%{inner_block: &__MODULE__.switching_indicator/2}]
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
                ])
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
                ])
            },
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
                    disabled: true,
                    meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
                  ]
                ]),
              trigger: [%{inner_block: &__MODULE__.custom_trigger/2}],
              content: [%{inner_block: &__MODULE__.custom_content/2}],
              indicator: [%{inner_block: &__MODULE__.custom_indicator/2}]
            }
          ]

  defdelegate accordion(assigns), to: Accordion
  defdelegate icon(assigns), to: CoreComponents

  def custom_trigger(_changed, item) do
    assigns = %{item: item}

    ~H"""
    <.icon name={@item.data.meta.icon} />{@item.data.trigger}
    """
  end

  def custom_content(_changed, item) do
    assigns = %{item: item}

    ~H"""
    {@item.data.content}
    """
  end

  def custom_indicator(_changed, item) do
    assigns = %{item: item}

    ~H"""
    <.icon name={@item.data.meta.indicator} />
    """
  end

  def indicator(_changed, item) do
    assigns = %{item: item}

    ~H"""
    <.icon name="hero-chevron-right" />
    """
  end

  def switching_indicator(_changed, item) do
    assigns = %{item: item}

    ~H"""
    <.icon name="hero-plus" class="state-closed" />
    <.icon name="hero-minus" class="state-open" />
    """
  end
end
