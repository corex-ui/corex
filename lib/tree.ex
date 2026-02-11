defmodule Corex.Tree do
  @moduledoc """
  Tree item structure for hierarchical/nested items.
  """

  defmodule Item do
    @moduledoc """
    Tree item structure.

    Use it to create hierarchical/nested structures for:
    - [Menu](Corex.Menu.html)

    ## Fields

    * `:id` - (optional) Unique identifier, auto-generated if not provided
    * `:label` - (required) Display text
    * `:children` - (optional) Nested items
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
      children: [],
      disabled: false,
      group: nil,
      meta: %{},
      redirect: nil,
      new_tab: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            label: String.t(),
            children: list(t()),
            disabled: boolean(),
            group: String.t() | nil,
            meta: map(),
            redirect: boolean() | nil,
            new_tab: boolean()
          }

    @doc """
    Creates a single Tree.Item with an auto-generated ID if not provided.
    Recursively processes children if present.

    Raises `ArgumentError` if attrs is not a keyword list or map.
    """
    def new(attrs) when is_list(attrs) or is_map(attrs) do
      attrs =
        attrs
        |> Enum.into([])
        |> Keyword.put_new(:id, Corex.Tree.generate_id())

      # Process children recursively
      attrs =
        if attrs[:children] do
          children =
            Enum.map(attrs[:children], fn
              %__MODULE__{} = child ->
                child

              child_attrs when is_list(child_attrs) or is_map(child_attrs) ->
                new(child_attrs)

              invalid ->
                raise ArgumentError, """
                Invalid child item: #{inspect(invalid)}

                Children must be keyword lists, maps, or Tree.Item structs.
                """
            end)

          Keyword.put(attrs, :children, children)
        else
          attrs
        end

      struct!(__MODULE__, attrs)
    rescue
      e in [KeyError, ArgumentError] ->
        reraise ArgumentError,
                """
                Failed to create Tree.Item: #{Exception.message(e)}

                Required fields: [:label]
                Optional fields: [:id, :children, :disabled, :group, :meta, :redirect, :new_tab]

                Example:
                  Corex.Tree.Item.new(label: "File", children: [
                    [label: "New"],
                    [label: "Open"]
                  ])
                """,
                __STACKTRACE__
    end

    def new(attrs) do
      raise ArgumentError, """
      Expected a keyword list or map, got: #{inspect(attrs)}

      Example:
        Corex.Tree.Item.new(label: "My Label")
        Corex.Tree.Item.new(%{label: "My Label", children: []})
      """
    end
  end

  @doc """
  Creates a list of Tree.Item structs from a list of attribute maps.
  Recursively processes children if present.

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
      Corex.Tree.new([
        [label: "File", children: [[label: "New"]]],
        [label: "Edit"]
      ])
    """
  end

  def new(items) do
    raise ArgumentError, """
    Expected a list, got: #{inspect(items)}

    Example:
      Corex.Tree.new([
        [label: "File"],
        [label: "Edit"]
      ])
    """
  end

  @doc false
  def generate_id do
    "tree-#{System.unique_integer([:positive, :monotonic])}"
  end
end
