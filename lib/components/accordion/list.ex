defmodule Corex.Accordion.Item do
  @moduledoc """
  List item structure for use with Accordion component.

  Use it to create a list of items for [Accordion](Corex.Accordion.html)

  ## Fields

  * `:trigger` - (required) Content to display in the accordion trigger/button
  * `:content` - (required) Content to display in the accordion panel
  * `:value` - (optional) Unique identifier for the item
  * `:disabled` - (optional) Whether the item is disabled
  * `:meta` - (optional) Additional metadata for the item

  The fields are available in the item slot as `{item.meta.trigger}` and `{item.meta.content}` etc

  ## Example

  This example assumes the import of `.icon` from `Core Components`

  ```heex
  <.accordion
    class="accordion"
    items={[
      %Corex.Accordion.Item{
        value: "lorem",
        trigger: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{
          indicator: "hero-chevron-right",
        }
      },
      %Corex.Accordion.Item{
        trigger: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{
          indicator: "hero-chevron-right",
        }
      },
      %Corex.Accordion.Item{
        value: "donec",
        trigger: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{
          indicator: "hero-chevron-right",
        }
      }
    ]}
  >
    <:item :let={item}>
      <.accordion_trigger item={item}>
        {item.meta.trigger}
        <:indicator>
          <.icon name={item.meta.indicator} />
        </:indicator>
      </.accordion_trigger>

      <.accordion_content item={item}>
        {item.meta.content}
      </.accordion_content>
    </:item>
  </.accordion>
  ```
  """

  @enforce_keys [:trigger, :content]
  defstruct [
    :value,
    :trigger,
    :content,
    :meta,
    disabled: false
  ]

  @type t :: %__MODULE__{
          value: String.t(),
          trigger: String.t(),
          content: String.t(),
          meta: map(),
          disabled: boolean()
        }
end
