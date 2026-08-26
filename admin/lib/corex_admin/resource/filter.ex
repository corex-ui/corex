defmodule CorexAdmin.Resource.Filter do
  @moduledoc false

  defstruct [:name, :type, :label, :options, :field]

  @type t :: %__MODULE__{
          name: atom(),
          type: atom(),
          label: String.t(),
          options: [term()] | nil,
          field: atom()
        }
end
