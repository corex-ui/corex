defmodule Corex.Content do
  @moduledoc ~S'''
   Content items for components with trigger/content patterns to be used with:

   - [Accordion](Corex.Accordion.html)
   - [Tabs](Corex.Tabs.html)

   Use `Corex.Content.new/1` to build a list of items from keyword lists or maps.

  '''

  defmodule Item do
    @moduledoc """
      Content item structure.
      Use it to create content items for components with trigger/content patterns:
      - [Accordion](Corex.Accordion.html)
      - [Tabs](Corex.Tabs.html)

    ## Examples

    ```elixir
        Corex.Content.Item.new(trigger: "Lorem", content: "Consectetur adipiscing elit.")
    ```
    """

    @enforce_keys [:trigger, :content]
    defstruct [
      :id,
      :value,
      :trigger,
      :content,
      :meta,
      disabled: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            trigger: String.t(),
            content: String.t(),
            meta: map(),
            disabled: boolean()
          }

    @doc """
    Creates a single Content.Item with an auto-generated ID if not provided.

    Raises `ArgumentError` if attrs is not a keyword list or map.
    """
    def new(attrs) when is_list(attrs) or is_map(attrs) do
      attrs =
        attrs
        |> Enum.into([])
        |> Keyword.put_new(:id, Corex.Content.generate_id())

      struct!(__MODULE__, attrs)
    rescue
      e in [KeyError, ArgumentError] ->
        reraise ArgumentError,
                """
                Failed to create Content.Item: #{Exception.message(e)}

                Required fields: [:trigger, :content]
                Optional fields: [:id, :value, :disabled, :meta]

                Example:
                  Corex.Content.Item.new(trigger: "Lorem", content: "Consectetur adipiscing elit.")
                """,
                __STACKTRACE__
    end

    def new(attrs) do
      raise ArgumentError, """
      Expected a keyword list or map, got: #{inspect(attrs)}

      Example:
        Corex.Content.Item.new(trigger: "Lorem", content: "Consectetur adipiscing elit.")
      """
    end
  end

  @doc """
  Creates a list of content items from a list of keyword lists or maps.

  * `:id` - (optional) Unique identifier, auto-generated if not provided
  * `:trigger` - (required) Content to display in the trigger
  * `:content` - (required) Content to display in the content
  * `:value` - (optional) Deprecated, use `:id`
  * `:disabled` - (optional) Whether the item is disabled
  * `:meta` - (optional) Additional metadata for the item

  ## Examples

      Corex.Content.new([
        [trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."],
        [id: "duis", trigger: "Duis", content: "Nullam eget vestibulum ligula."],
        [id: "donec", trigger: "Donec", content: "Congue molestie ipsum gravida a.", disabled: true]
      ])

  Raises `ArgumentError` if items is not a list or contains invalid items.
  """

  def new([]), do: []

  def new([first | _rest] = items) when is_list(first) or is_map(first) do
    Enum.map(items, &Item.new/1)
  end

  @spec new(list(keyword() | map())) :: list(Item.t())
  def new(items) when is_list(items) do
    raise ArgumentError, """
    Expected a list of keyword lists or maps, got invalid item format.

    Example:
      Corex.Content.new([
        [trigger: "Lorem: "Consectetur adipiscing elit."],
        [trigger: "Duis", content: "Nullam eget vestibulum ligula."],
        [trigger: "Donec", content: "Congue molestie ipsum gravida a."]
      ])
    """
  end

  def new(items) do
    raise ArgumentError, """
    Expected a list, got: #{inspect(items)}

    Example:
      Corex.Content.new([
        [trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."],
        [trigger: "Duis", content: "Nullam eget vestibulum ligula."],
        [trigger: "Donec", content: "Congue molestie ipsum gravida a."]
      ])
    """
  end

  @doc false
  def generate_id do
    "content-#{System.unique_integer([:positive, :monotonic])}"
  end
end
