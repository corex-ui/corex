defmodule Corex.DataList.Item do
  @moduledoc ~S'''
  Struct for data items used in:

  - [DataList](Corex.DataList.html)

  Use `Corex.DataList.Item.new/1` to build a list of items from a list of maps.

  ## Fields

  - `:title` (required) - the label/title of the item
  - `:value` (optional) - the value of the item, auto-generated as `"item-N"` when omitted
  - `:meta` (optional) - any extra data for custom rendering

  ## Examples

      Corex.DataList.Item.new([
        %{title: "Name", value: "Marie Curie"},
        %{title: "Status", value: "Active", meta: %{color: "green"}}
      ])
  '''

  @enforce_keys [:title, :value]
  defstruct [:title, :value, meta: %{}]

  @type t :: %__MODULE__{
          title: String.t(),
          value: any(),
          meta: map()
        }

  @doc """
  Creates a single `DataList.Item` from a map, auto-generating `:value` as `"item-N"` when not provided.

  Raises `ArgumentError` if `attrs` is not a map or is missing required fields.
  """
  @spec build(map()) :: t()
  def build(attrs) when is_map(attrs) do
    attrs = Map.put_new(attrs, :value, generate_value())
    struct!(__MODULE__, attrs)
  rescue
    e in [KeyError, ArgumentError] ->
      reraise ArgumentError,
              """
              Failed to create Corex.DataList.Item: #{Exception.message(e)}

              Required fields: [:title]
              Optional fields: [:value, :meta]

              Example:
                Corex.DataList.Item.build(%{title: "Name", value: "Ada"})
              """,
              __STACKTRACE__
  end

  def build(attrs) do
    raise ArgumentError, """
    Expected a map, got: #{inspect(attrs)}

    Example:
      Corex.DataList.Item.build(%{title: "Name", value: "Ada"})
    """
  end

  @doc """
  Creates a list of `%Corex.DataList.Item{}` structs from a list of maps.

  Auto-generates `:value` as `"item-N"` (1-based index) when not provided.

  ## Examples

      iex> Corex.DataList.Item.new([%{title: "Name", value: "Ada"}])
      [%Corex.DataList.Item{title: "Name", value: "Ada", meta: %{}}]

      iex> Corex.DataList.Item.new([%{title: "Status", value: "Active", meta: %{color: "green"}}])
      [%Corex.DataList.Item{title: "Status", value: "Active", meta: %{color: "green"}}]

      iex> Corex.DataList.Item.new([%{title: "Name"}, %{title: "Status"}])
      [
        %Corex.DataList.Item{title: "Name", value: "item-1", meta: %{}},
        %Corex.DataList.Item{title: "Status", value: "item-2", meta: %{}}
      ]

  Raises `ArgumentError` if `items` is not a list of maps.
  """
  @spec new(list(map())) :: list(t())
  def new([]), do: []

  def new([first | _rest] = items) when is_map(first) do
    items
    |> Enum.with_index(1)
    |> Enum.map(fn {attrs, index} ->
      attrs = Map.put_new(attrs, :value, "item-#{index}")

      struct!(__MODULE__, attrs)
    end)
  rescue
    e in [KeyError, ArgumentError] ->
      reraise ArgumentError,
              """
              Failed to create Corex.DataList.Item list: #{Exception.message(e)}

              Required fields: [:title]
              Optional fields: [:value, :meta]

              Example:
                Corex.DataList.Item.new([
                  %{title: "Name", value: "Ada"},
                  %{title: "Status", value: "Active", meta: %{color: "green"}}
                ])
              """,
              __STACKTRACE__
  end

  def new(items) when is_list(items) do
    raise ArgumentError, """
    Expected a list of maps, but the list contains non-map items.

    Example:
      Corex.DataList.Item.new([
        %{title: "Name", value: "Ada"},
        %{title: "Status", value: "Active"}
      ])
    """
  end

  def new(items) do
    raise ArgumentError, """
    Expected a list of maps, got: #{inspect(items)}

    Example:
      Corex.DataList.Item.new([
        %{title: "Name", value: "Ada"}
      ])
    """
  end

  @doc false
  def generate_value do
    "item-#{System.unique_integer([:positive, :monotonic])}"
  end
end
