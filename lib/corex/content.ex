defmodule Corex.Content do
  @moduledoc ~S'''
  Content items for components with trigger/content patterns to be used with:

  - [Accordion](Corex.Accordion.html)
  - [Tabs](Corex.Tabs.html)

  Use `Corex.Content.new/1` to build a list of items from maps or keyword lists.
  '''

  defmodule Item do
    @moduledoc """
    Content item structure.
    Use it to create content items for components with trigger/content patterns:
    - [Accordion](Corex.Accordion.html)
    - [Tabs](Corex.Tabs.html)

    ## Examples

        Corex.Content.Item.new(%{label: "Lorem", content: "Consectetur adipiscing elit."})

    """

    @enforce_keys [:value, :label, :content]
    defstruct [
      :value,
      :label,
      :content,
      :meta,
      disabled: false
    ]

    @type t :: %__MODULE__{
            value: String.t(),
            label: String.t(),
            content: String.t(),
            meta: map(),
            disabled: boolean()
          }

    @doc """
    Creates a single `Content.Item` from a map, auto-generating `:value` if not provided.

    Raises `ArgumentError` if `attrs` is not a map or is missing `:label` or `:content`.
    A unique `:value` is generated when omitted.
    """
    @spec new(map()) :: t()
    def new(attrs) when is_map(attrs) do
      attrs =
        attrs
        |> Map.put_new_lazy(:value, fn -> Corex.Content.generate_id() end)

      struct!(__MODULE__, attrs)
    rescue
      e in [KeyError, ArgumentError] ->
        reraise ArgumentError,
                """
                Failed to create Content.Item: #{Exception.message(e)}

                Required fields: [:label, :content]
                Optional fields: [:value, :disabled, :meta]

                Example:
                  Corex.Content.Item.new(%{value: "item-1", label: "Lorem", content: "Consectetur adipiscing elit."})
                """,
                __STACKTRACE__
    end

    def new(attrs) do
      raise ArgumentError, """
      Expected a map, got: #{inspect(attrs)}

      Example:
        Corex.Content.Item.new(%{value: "item-1", label: "Lorem", content: "Consectetur adipiscing elit."})
      """
    end
  end

  @doc """
  Creates a list of `Content.Item` structs from a list of maps or keyword lists.

  ## Fields

  * `:label` - (required) Text shown in the trigger/header region
  * `:content` - (required) Content to display in the content area
  * `:value` - (optional) Unique identifier (`item-1`, `item-2`, … when omitted)
  * `:disabled` - (optional) Whether the item is disabled, defaults to `false`
  * `:meta` - (optional) Additional metadata map for the item

  ## Examples

      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{value: "duis", label: "Duis", content: "Nullam eget vestibulum ligula."},
        %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a.", disabled: true}
      ])

  Raises `ArgumentError` if `items` is not a list of maps or keyword lists.
  """
  @spec new(list()) :: list(Item.t())
  def new([]), do: []

  def new([first | _] = items) when is_map(first) do
    build_from_rows(items)
  end

  def new([first | _] = items) when is_list(first) do
    if Keyword.keyword?(first) do
      build_from_rows(items)
    else
      raise ArgumentError, """
      Expected a list of maps or keyword lists, but the list contains invalid items.

      Example:
        Corex.Content.new([
          %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
          %{label: "Duis", content: "Nullam eget vestibulum ligula."},
          %{label: "Donec", content: "Congue molestie ipsum gravida a."}
        ])
      """
    end
  end

  def new(items) when is_list(items) do
    raise ArgumentError, """
    Expected a list of maps or keyword lists, but the list contains invalid items.

    Example:
      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{label: "Duis", content: "Nullam eget vestibulum ligula."},
        %{label: "Donec", content: "Congue molestie ipsum gravida a."}
      ])
    """
  end

  def new(items) do
    raise ArgumentError, """
    Expected a list of maps or keyword lists, got: #{inspect(items)}

    Example:
      Corex.Content.new([
        %{label: "Lorem ipsum dolor sit amet", content: "Consectetur adipiscing elit."},
        %{label: "Duis", content: "Nullam eget vestibulum ligula."},
        %{label: "Donec", content: "Congue molestie ipsum gravida a."}
      ])
    """
  end

  defp build_from_rows(items) do
    items
    |> Enum.with_index(1)
    |> Enum.map(fn {row, index} ->
      row
      |> row_to_map()
      |> Map.put_new(:value, "item-#{index}")
      |> Item.new()
    end)
  end

  defp row_to_map(%{} = m), do: m

  defp row_to_map(kw) when is_list(kw) do
    if Keyword.keyword?(kw) do
      Enum.into(kw, %{})
    else
      raise ArgumentError, """
      Expected a map or keyword list for each content row.

      Example:
        Corex.Content.new([
          %{label: "Lorem", content: "…"},
          [label: "Duis", content: "…"]
        ])
      """
    end
  end

  defp row_to_map(other) do
    raise ArgumentError, """
    Expected a map or keyword list for each content row, got: #{inspect(other)}
    """
  end

  @doc false
  def generate_id do
    "content-#{System.unique_integer([:positive, :monotonic])}"
  end
end
