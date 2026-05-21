defmodule Corex.List do
  @moduledoc ~S'''
  Flat selectable items for [Combobox](Corex.Combobox.html), [Listbox](Corex.Listbox.html), and [Select](Corex.Select.html).

  Build items with `Corex.List.new/1` or `Corex.List.Item.new/1`. Each row is a `Corex.List.Item` with required `:label` and optional `:value` (defaults to `item-1`, `item-2`, … when built through `new/1`, or `list-<integer>` from `generate_id/0` when built only through `Item.new/1`), plus `:to`, `:redirect`, `:new_tab`, `:disabled`, `:group`, and `:meta`.

  When the parent sets `redirect`, selection can navigate using each item’s `:to` or value as destination; per-item `:redirect` is `:href`, `:patch`, `:navigate`, or `false` to opt out. With `redirect` enabled, the client runs single-select in Zag even if the form uses `multiple`.
  '''

  defmodule Item do
    @moduledoc """
    One selectable row for Combobox, Listbox, or Select.

    ## Fields

    * `:label` (required)  -  visible text
    * `:value` (optional)  -  submitted option value; defaults when built through `Corex.List.new/1` (`item-1`, …) or `Item.new/1` alone (`list-<integer>`)
    * `:to` (optional)  -  URL or path used for redirect-on-select when the parent has `redirect`
    * `:disabled` (optional)
    * `:group` (optional)  -  group id for grouped lists
    * `:meta` (optional)  -  arbitrary map
    * `:redirect` (optional)  -  `:href` | `:patch` | `:navigate` | `false`; controls navigation kind for this item when the parent has `redirect`
    * `:new_tab` (optional)  -  open redirect target in a new tab
    """

    @enforce_keys [:label]
    defstruct [
      :value,
      :to,
      :label,
      disabled: false,
      group: nil,
      meta: %{},
      redirect: nil,
      new_tab: false
    ]

    @type redirect_mode :: :href | :patch | :navigate | false | nil

    @type t :: %__MODULE__{
            value: String.t(),
            to: String.t() | nil,
            label: String.t(),
            disabled: boolean(),
            group: String.t() | nil,
            meta: map(),
            redirect: redirect_mode(),
            new_tab: boolean()
          }

    @doc """
    Creates a single List.Item with an auto-generated value if not provided.

    Raises `ArgumentError` if attrs is not a keyword list or map.
    """
    def new(attrs) when is_list(attrs) or is_map(attrs), do: new(attrs, [])

    def new(attrs) do
      raise ArgumentError, """
      Expected a keyword list or map, got: #{inspect(attrs)}

      Example:
        Corex.List.Item.new(label: "My Label")
        Corex.List.Item.new(%{label: "My Label"})
      """
    end

    def new(attrs, opts) when is_list(attrs) or is_map(attrs) do
      Corex.ItemBuilder.build_item(
        __MODULE__,
        attrs,
        Keyword.merge(opts,
          id_prefix: "list",
          required_fields: [:label],
          optional_fields: [:value, :to, :disabled, :group, :meta, :redirect, :new_tab],
          example: "Corex.List.Item.new(label: \"My Label\")"
        )
      )
    end
  end

  @doc """
  Creates a list of List.Item structs from a list of attribute maps.

  For each map or keyword list, if `:value` is omitted, it is set to `"item-<index>"` (1-based), matching `Corex.Content.new/1`.

  Raises `ArgumentError` if items is not a list or contains invalid items.
  """
  def new([]), do: []

  def new(items) when is_list(items) do
    items
    |> Enum.with_index(1)
    |> Enum.map(fn
      {%Item{} = item, _index} ->
        item

      {item, index} when is_list(item) or is_map(item) ->
        Item.new(item, index: index)

      {other, _index} ->
        raise ArgumentError, """
        Expected keyword lists, maps, or %Corex.List.Item{}, got: #{inspect(other)}

        Example:
          Corex.List.new([
            [label: "Option 1"],
            [label: "Option 2"]
          ])
        """
    end)
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
end
