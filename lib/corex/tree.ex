defmodule Corex.Tree do
  @moduledoc ~S'''
  Tree items for hierarchical/nested structures to be used with:

  - [Menu](Corex.Menu.html)
  - [TreeView](Corex.TreeView.html)

  Use `Corex.Tree.new/1` to build a list of items from a list of maps.

  ## What the `items` attr accepts

  Menu and TreeView accept `Corex.Tree.Item` structs only, and this is the whole
  contract. A plain map raises with the `new/1` call that would have built it,
  unlike `Corex.List`, which coerces: a tree is authored in a template rather than
  mapped from a query result, so a wrong shape is a developer mistake to surface
  rather than a bad row to skip.

  Each item requires `:label`. `:value` is generated when absent, `:children`
  nests further items, and `:to`, `:redirect`, `:new_tab`, `:disabled`, `:group`
  and `:meta` are optional. Shared fields match content and list items
  (`:value`, `:label`, `:disabled`, `:meta`), plus the navigation set above.
  '''

  defmodule Item do
    @moduledoc """
    Tree item structure.

    Use it to create hierarchical/nested structures for:
    - [Menu](Corex.Menu.html)
    - [TreeView](Corex.TreeView.html)

    ## Fields

    * `:value` - (optional) Unique node value, auto-generated if not provided
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
      :value,
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
            value: String.t(),
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
    Creates a single `Tree.Item` from a map, auto-generating a `:value` if not provided
    and recursively processing `:children`.

    Raises `ArgumentError` if `attrs` is not a map or is missing required fields,
    or if a child is neither a map nor a `Tree.Item` struct.
    """
    @spec new(map()) :: t()
    def new(%__MODULE__{} = item), do: item

    def new(attrs) when is_map(attrs) do
      attrs = maybe_process_children(attrs)

      Corex.ItemBuilder.build_item(__MODULE__, attrs,
        id_prefix: "tree",
        required_fields: [:label],
        optional_fields: [:value, :to, :children, :disabled, :group, :meta, :redirect, :new_tab],
        example:
          "Corex.Tree.Item.new(%{label: \"File\", to: \"/file\", children: [%{label: \"New\"}, %{label: \"Open\"}]})"
      )
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
  * `:value` - (optional) Unique node value, auto-generated if not provided
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
  @spec validate_items_assigns!(map(), keyword()) :: map()
  def validate_items_assigns!(assigns, opts) do
    component = Keyword.fetch!(opts, :component)

    Corex.Item.assert_items!(
      assigns,
      Item,
      opts
      |> Keyword.put_new(:example, default_tree_example(component))
      |> Keyword.put_new(:required, false)
    )
  end

  defp default_tree_example("tree_view") do
    """
        items = Corex.Tree.new([
          %{label: "Src", value: "src", children: [%{label: "index.ts", value: "src/index"}]},
          %{label: "Readme", value: "readme"}
        ])
        <.tree_view id="my-tree" items={items} />
    """
  end

  defp default_tree_example(_component) do
    """
        items = Corex.Tree.new([
          %{label: "Edit", value: "edit"},
          %{label: "Copy", value: "copy"}
        ])
        <.menu id="my-menu" items={items}>
          <:trigger>Actions</:trigger>
        </.menu>
    """
  end
end
