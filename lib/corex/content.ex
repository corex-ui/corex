defmodule Corex.Content do
  @moduledoc ~S'''
  Content items for components with trigger/content patterns to be used with:

  - [Accordion](Corex.Accordion.html)
  - [Tabs](Corex.Tabs.html)

  Use `Corex.Content.new/1` to build a list of items from maps.
  '''

  defmodule Item do
    @moduledoc """
    Content item structure.
    Use it to create content items for components with trigger/content patterns:
    - [Accordion](Corex.Accordion.html)
    - [Tabs](Corex.Tabs.html)

    ## Examples

        Corex.Content.Item.new(%{trigger: "Lorem", content: "Consectetur adipiscing elit."})

    """

    @enforce_keys [:value, :trigger, :content]
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

    @doc """
    Creates a single `Content.Item` from a map, auto-generating an ID if not provided.

    Raises `ArgumentError` if `attrs` is not a map or is missing required fields.
    """
    @spec new(map()) :: t()
    def new(attrs) when is_map(attrs) do
      struct!(__MODULE__, attrs)
    rescue
      e in [KeyError, ArgumentError] ->
        reraise ArgumentError,
                """
                Failed to create Content.Item: #{Exception.message(e)}

                Required fields: [:value, :trigger, :content]
                Optional fields: [:value, :disabled, :meta]

                Example:
                  Corex.Content.Item.new(%{value: "item-1", trigger: "Lorem", content: "Consectetur adipiscing elit."})
                """,
                __STACKTRACE__
    end

    def new(attrs) do
      raise ArgumentError, """
      Expected a map, got: #{inspect(attrs)}

      Example:
        Corex.Content.Item.new(%{value: "item-1", trigger: "Lorem", content: "Consectetur adipiscing elit."})
      """
    end
  end

  @doc """
  Creates a list of `Content.Item` structs from a list of maps.

  ## Fields

  * `:trigger` - (required) Content to display in the trigger
  * `:content` - (required) Content to display in the content area
  * `:value` - (optional) Unique identifier
  * `:disabled` - (optional) Whether the item is disabled, defaults to `false`
  * `:meta` - (optional) Additional metadata map for the item

  ## Examples

      Corex.Content.new([
        %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{value: "duis", trigger: "Duis", content: "Nullam eget vestibulum ligula."},
        %{value: "donec", trigger: "Donec", content: "Congue molestie ipsum gravida a.", disabled: true}
      ])

  Raises `ArgumentError` if `items` is not a list of maps.
  """
  @spec new(list(map())) :: list(Item.t())
  def new([]), do: []

  def new([first | _rest] = items) when is_map(first) do
    items
    |> Enum.with_index(1)
    |> Enum.map(fn {attrs, index} ->
      attrs = Map.put_new(attrs, :value, "item-#{index}")
      Item.new(attrs)
    end)
  end

  def new(items) when is_list(items) do
    raise ArgumentError, """
    Expected a list of maps, but the list contains non-map items.

    Example:
      Corex.Content.new([
        %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{trigger: "Duis", content: "Nullam eget vestibulum ligula."},
        %{trigger: "Donec", content: "Congue molestie ipsum gravida a."}
      ])
    """
  end

  def new(items) do
    raise ArgumentError, """
    Expected a list of maps, got: #{inspect(items)}

    Example:
      Corex.Content.new([
        %{trigger: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{trigger: "Duis", content: "Nullam eget vestibulum ligula."},
        %{trigger: "Donec", content: "Congue molestie ipsum gravida a."}
      ])
    """
  end

  @doc false
  def generate_id do
    "content-#{System.unique_integer([:positive, :monotonic])}"
  end
end
