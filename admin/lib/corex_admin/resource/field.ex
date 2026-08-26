defmodule CorexAdmin.Resource.Field do
  @moduledoc false

  defstruct [
    :name,
    :type,
    :label,
    readable: true,
    writable: true,
    searchable: false,
    sortable: false,
    filterable: false,
    redact: false,
    index: true,
    show: true,
    options: nil,
    schema: nil,
    fields: []
  ]

  @type t :: %__MODULE__{
          name: atom(),
          type: atom(),
          label: String.t(),
          readable: boolean(),
          writable: boolean(),
          searchable: boolean(),
          sortable: boolean(),
          filterable: boolean(),
          redact: boolean(),
          index: boolean(),
          show: boolean(),
          options: [term()] | nil,
          schema: module() | nil,
          fields: [t()]
        }
end
