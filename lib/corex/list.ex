defmodule Corex.List do
  @moduledoc ~S'''
  List items for flat selectable items to be used with:

  - [Combobox](Corex.Combobox.html)
  - [Listbox](Corex.Listbox.html)
  - [Select](Corex.Select.html)

  Use `Corex.List.new/1` to build a list of items from keyword lists or maps.

  '''

  defmodule Item do
    @moduledoc """
    List item structure.

    Use it to create flat lists of selectable items for:
    - [Combobox](Corex.Combobox.html)
    - [Listbox](Corex.Listbox.html)
    - [Select](Corex.Select.html)

    ## Fields

    * `:id` - (optional) Unique identifier, auto-generated if not provided
    * `:label` - (required) Display text
    * `:disabled` - (optional) Whether the item is disabled
    * `:group` - (optional) Group identifier for grouping items
    * `:meta` - (optional) Additional metadata for the item
    * `:redirect` - (optional) When top-level redirect is true, set to false on an item to disable redirect for that item
    * `:new_tab` - (optional) When redirect is used, set to true to open this item's URL in a new tab
    """

    @derive Jason.Encoder
    @enforce_keys [:label]
    defstruct [
      :id,
      :label,
      disabled: false,
      group: nil,
      meta: %{},
      redirect: nil,
      new_tab: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            label: String.t(),
            disabled: boolean(),
            group: String.t() | nil,
            meta: map(),
            redirect: boolean() | nil,
            new_tab: boolean()
          }

    @doc """
    Creates a single List.Item with an auto-generated ID if not provided.

    Raises `ArgumentError` if attrs is not a keyword list or map.
    """
    def new(attrs) when is_list(attrs) or is_map(attrs) do
      attrs =
        attrs
        |> Enum.into([])
        |> Keyword.put_new(:id, Corex.List.generate_id())

      struct!(__MODULE__, attrs)
    rescue
      e in [KeyError, ArgumentError] ->
        reraise ArgumentError,
                """
                Failed to create List.Item: #{Exception.message(e)}

                Required fields: [:label]
                Optional fields: [:id, :disabled, :group, :meta, :redirect, :new_tab]

                Example:
                  Corex.List.Item.new(label: "My Label")
                """,
                __STACKTRACE__
    end

    def new(attrs) do
      raise ArgumentError, """
      Expected a keyword list or map, got: #{inspect(attrs)}

      Example:
        Corex.List.Item.new(label: "My Label")
        Corex.List.Item.new(%{label: "My Label"})
      """
    end
  end

  @doc """
  Creates a list of List.Item structs from a list of attribute maps.

  Raises `ArgumentError` if items is not a list or contains invalid items.
  """
  def new([]), do: []

  def new([first | _rest] = items) when is_list(first) or is_map(first) do
    Enum.map(items, &Item.new/1)
  end

  def new(items) when is_list(items) do
    raise ArgumentError, """
    Expected a list of keyword lists or maps, got invalid item format.

    Example:
      Corex.List.new([
        [label: "Option 1"],
        [label: "Option 2"]
      ])
    """
  end

  def new(items) do
    raise ArgumentError, """
    Expected a list, got: #{inspect(items)}

    Example:
      Corex.List.new([
        [label: "Option 1"],
        [label: "Option 2"]
      ])
    """
  end

  @doc false
  def generate_id do
    "list-#{System.unique_integer([:positive, :monotonic])}"
  end
end
