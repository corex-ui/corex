defmodule CorexAdmin.Resource.Spec do
  @moduledoc false

  alias CorexAdmin.Resource.{Field, Filter, Section}

  @enforce_keys [:module, :context, :schema, :slug, :label, :actions, :fields]
  defstruct [
    :module,
    :context,
    :schema,
    :slug,
    :group,
    :label,
    :singular,
    :scope,
    :primary_key,
    :page_size,
    :page_size_options,
    :default_sort,
    :title_field,
    :history,
    live: %{},
    history_opts: [],
    selectable: true,
    default_filters: %{},
    actions: %{},
    collection_actions: [],
    bulk_actions: [],
    record_actions: [],
    fields: [],
    filters: [],
    form_sections: [],
    show_sections: []
  ]

  @type t :: %__MODULE__{
          module: module(),
          context: module(),
          schema: module(),
          slug: String.t(),
          group: String.t() | nil,
          label: String.t(),
          singular: String.t(),
          scope: atom() | nil,
          primary_key: atom(),
          page_size: pos_integer() | nil,
          page_size_options: [pos_integer()] | nil,
          default_sort: {atom(), :asc | :desc} | nil,
          title_field: atom() | nil,
          history: module() | nil,
          live: %{optional(:index | :show | :form) => module()},
          history_opts: keyword(),
          selectable: boolean(),
          default_filters: map(),
          actions: %{atom() => atom()},
          collection_actions: [module()],
          bulk_actions: [module()],
          record_actions: [module()],
          fields: [Field.t()],
          filters: [Filter.t()],
          form_sections: [Section.t()],
          show_sections: [Section.t()]
        }
end
