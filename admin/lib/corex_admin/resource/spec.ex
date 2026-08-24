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
          actions: %{atom() => atom()},
          fields: [Field.t()],
          filters: [Filter.t()]
        }
end
