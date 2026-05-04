defmodule Corex.Tree do
  @moduledoc ~S'''
  Tree items for hierarchical/nested structures to be used with:

  - [Menu](Corex.Menu.html)
  - [TreeView](Corex.TreeView.html)

  Use `Corex.Tree.new/1` to build a list of items from a list of maps.
  '''

  defmodule Item do
    @moduledoc """
    Tree item structure.

    Use it to create hierarchical/nested structures for:
    - [Menu](Corex.Menu.html)
    - [TreeView](Corex.TreeView.html)

    ## Fields

    * `:id` - (optional) Unique identifier, auto-generated if not provided
    * `:label` - (required) Display text
    * `:to` - (optional) Destination (path or URL) used by navigation components
    * `:children` - (optional) Nested items (list of maps)
    * `:disabled` - (optional) Whether the item is disabled
    * `:group` - (optional) Group identifier for grouping items
    * `:meta` - (optional) Additional metadata for the item
    * `:redirect` - (optional) Per-item navigation mode: `:href` (default, full page redirect),
      `:patch` (LiveView `js().patch`, same mount), `:navigate` (LiveView `js().navigate`,
      another mount in the same `live_session`), or `false` to disable redirect for this item.
      The hook never inspects the URL to guess the mode; it only executes what is declared here.
    * `:new_tab` - (optional) Open the item's destination in a new tab via `window.open` (mode is ignored when `true`)

    ## Examples

        Corex.Tree.Item.new(%{label: "File", children: [%{label: "New"}, %{label: "Open"}]})

    """

    @enforce_keys [:label]
    defstruct [
      :id,
      :label,
      :to,
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
            to: String.t() | nil,
            children: list(t()),
            disabled: boolean(),
            group: String.t() | nil,
            meta: map(),
            redirect: :href | :patch | :navigate | false | nil,
            new_tab: boolean()
          }

    @doc """
    Creates a single `Tree.Item` from a map, auto-generating an `:id` if not provided
    and recursively processing `:children`.

    Raises `ArgumentError` if `attrs` is not a map or is missing required fields,
    or if a child is neither a map nor a `Tree.Item` struct.
    """
    @spec new(map()) :: t()
    def new(%__MODULE__{} = item), do: item

    def new(attrs) when is_map(attrs) do
      attrs =
        attrs
        |> Map.put_new(:id, Corex.Tree.generate_id())
        |> maybe_process_children()

      struct!(__MODULE__, attrs)
    rescue
      e in [KeyError, ArgumentError] ->
        reraise ArgumentError,
                """
                Failed to create Tree.Item: #{Exception.message(e)}

                Required fields: [:label]
                Optional fields: [:id, :to, :children, :disabled, :group, :meta, :redirect, :new_tab]

                Example:
                  Corex.Tree.Item.new(%{label: "File", to: "/file", children: [
                    %{label: "New"},
                    %{label: "Open"}
                  ]})
                """,
                __STACKTRACE__
    end

    def new(attrs) do
      raise ArgumentError, """
      Expected a map, got: #{inspect(attrs)}

      Example:
        Corex.Tree.Item.new(%{label: "My Label"})
        Corex.Tree.Item.new(%{label: "Parent", children: [%{label: "Child"}]})
      """
    end

    defp maybe_process_children(%{children: children} = attrs) when is_list(children) do
      Map.put(attrs, :children, Enum.map(children, &cast_child/1))
    end

    defp maybe_process_children(attrs), do: attrs

    defp cast_child(%__MODULE__{} = child), do: child
    defp cast_child(attrs) when is_map(attrs), do: new(attrs)

    defp cast_child(invalid) do
      raise ArgumentError, """
      Invalid child item: #{inspect(invalid)}

      Children must be maps or Tree.Item structs.
      """
    end
  end

  @doc """
  Creates a list of `Tree.Item` structs from a list of maps.
  Recursively processes `:children` if present.

  ## Fields

  * `:label` - (required) Display text
  * `:id` - (optional) Unique identifier, auto-generated if not provided
  * `:to` - (optional) Destination (path or URL)
  * `:children` - (optional) Nested items (list of maps)
  * `:disabled` - (optional) Whether the item is disabled
  * `:group` - (optional) Group identifier
  * `:meta` - (optional) Additional metadata
  * `:redirect` - (optional) `:href` | `:patch` | `:navigate` | `false`
  * `:new_tab` - (optional) Open the destination in a new tab

  ## Examples

      Corex.Tree.new([
        %{label: "File", children: [
          %{label: "New"},
          %{label: "Open"}
        ]},
        %{label: "Edit"}
      ])

  Raises `ArgumentError` if `items` is not a list of maps.
  """
  @spec new(list(map())) :: list(Item.t())
  def new([]), do: []

  def new([first | _rest] = items) when is_map(first) do
    Enum.map(items, &Item.new/1)
  end

  def new(items) when is_list(items) do
    raise ArgumentError, """
    Expected a list of maps, but the list contains non-map items.

    Example:
      Corex.Tree.new([
        %{label: "File", children: [%{label: "New"}]},
        %{label: "Edit"}
      ])
    """
  end

  def new(items) do
    raise ArgumentError, """
    Expected a list of maps, got: #{inspect(items)}

    Example:
      Corex.Tree.new([
        %{label: "File"},
        %{label: "Edit"}
      ])
    """
  end

  @doc false
  def generate_id do
    "tree-#{System.unique_integer([:positive, :monotonic])}"
  end
end
