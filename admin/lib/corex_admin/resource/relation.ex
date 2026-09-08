defmodule CorexAdmin.Resource.Relation do
  @moduledoc """
  How a relation field finds its options and renders its rows.

  Corex Admin never queries associations itself. A relation names a **context
  function** that returns candidate records, so scoping, preloads, and limits
  stay in the host:

      field :author, :belongs_to,
        relation: [
          context: MyApp.Blog,
          list: :list_authors,
          label: :name,
          search: true
        ]

  `list` is called as `list.(scope, opts)` when the resource declares `scope/1`,
  otherwise `list.(opts)`. `opts` is a keyword list carrying `:query` (the
  combobox text) and `:limit`.
  """

  defstruct [
    :context,
    :list,
    :schema,
    :owner_key,
    :related_key,
    label: :id,
    value: :id,
    search: false,
    limit: 50,
    columns: [],
    cardinality: :one
  ]

  @type t :: %__MODULE__{
          context: module() | nil,
          list: atom() | nil,
          schema: module() | nil,
          owner_key: atom() | nil,
          related_key: atom() | nil,
          label: atom() | (term() -> String.t()),
          value: atom(),
          search: boolean(),
          limit: pos_integer(),
          columns: [atom()],
          cardinality: :one | :many
        }

  @doc "Display string for one related record."
  @spec label(t(), term()) :: String.t()
  def label(%__MODULE__{label: label}, record) when is_function(label, 1) do
    to_string(label.(record))
  end

  def label(%__MODULE__{label: key}, record) when is_atom(key) do
    case Map.get(record || %{}, key) do
      nil -> ""
      value -> to_string(value)
    end
  end

  @doc "Option value for one related record, as a string for form params."
  @spec value(t(), term()) :: String.t()
  def value(%__MODULE__{value: key}, record) do
    case Map.get(record || %{}, key) do
      nil -> ""
      value -> to_string(value)
    end
  end

  @doc "Whether this relation holds many records."
  @spec many?(t()) :: boolean()
  def many?(%__MODULE__{cardinality: :many}), do: true
  def many?(_), do: false
end
