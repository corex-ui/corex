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
    options: nil
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
          options: [term()] | nil
        }
end
