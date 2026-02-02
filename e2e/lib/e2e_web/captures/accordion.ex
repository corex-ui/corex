defmodule E2eWeb.Captures.Accordion do
  use Phoenix.Component
  use E2eWeb.LiveCapture

  alias Corex.Accordion
  alias Corex.Accordion.Anatomy.Item

  capture attributes: %{
            id: "accordion-capture",
            value: ["item-0"],
            class: "accordion",
            item: [
              %{
                inner_block: """
                <.accordion_trigger item={item(@id, "item-0", @value)}>
                  Lorem ipsum dolor sit amet
                </.accordion_trigger>

                <.accordion_content item={item(@id, "item-0", @value)}>
                  Consectetur adipiscing elit.
                </.accordion_content>
                """
              },
              %{
                inner_block: """
                <.accordion_trigger item={item(@id, "item-1", @value)}>
                  Duis dictum gravida odio ac pharetra?
                </.accordion_trigger>

                <.accordion_content item={item(@id, "item-1", @value)}>
                  Nullam eget vestibulum ligula, at interdum tellus.
                </.accordion_content>
                """
              }
            ]
          }

  defdelegate accordion(assigns), to: Accordion
  defdelegate accordion_trigger(assigns), to: Accordion
  defdelegate accordion_content(assigns), to: Accordion

  def item(id, value, values), do: %Item{id: id, value: value, values: values}
end
