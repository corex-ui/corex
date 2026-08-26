defmodule CorexAdmin.Resource.Spec do
  @moduledoc false

  alias CorexAdmin.Resource.{Field, Filter}

  @enforce_keys [:module, :context, :schema, :slug, :label, :actions, :fields]
  defstruct [
    :module,
    :context,
    :schema,
    :slug,
    :group,
    :label,
    :scope,
    :primary_key,
    :page_size,
    :page_size_options,
    :default_sort,
    :title_field,
    selectable: true,
    filters_open: true,
    default_filters: %{},
    actions: %{},
    fields: [],
    filters: []
  ]

  @type t :: %__MODULE__{
          module: module(),
          context: module(),
          schema: module(),
          slug: String.t(),
          group: String.t() | nil,
          label: String.t(),
          scope: atom() | nil,
          primary_key: atom(),
          page_size: pos_integer() | nil,
          page_size_options: [pos_integer()] | nil,
          default_sort: {atom(), :asc | :desc} | nil,
          title_field: atom() | nil,
          selectable: boolean(),
          filters_open: boolean(),
          default_filters: map(),
          actions: %{atom() => atom()},
          fields: [Field.t()],
          filters: [Filter.t()]
        }
end
