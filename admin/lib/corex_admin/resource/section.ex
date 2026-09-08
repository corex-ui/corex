defmodule CorexAdmin.Resource.Section do
  @moduledoc false

  defstruct [:name, :label, fields: []]

  @type t :: %__MODULE__{
          name: String.t(),
          label: String.t() | nil,
          fields: [atom()]
        }
end
