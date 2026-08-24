defmodule CorexAdmin.Resource.Filter do
  @moduledoc false

  defstruct [:name, :type, :label, :options]

  @type t :: %__MODULE__{
          name: atom(),
          type: atom(),
          label: String.t(),
          options: [term()] | nil
        }
end
