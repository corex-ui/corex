defmodule CorexAdmin.Page do
  @moduledoc """
  A page of records returned by a context `list/2` function.
  """

  @enforce_keys [:entries, :total, :page, :page_size]
  defstruct [:entries, :total, :page, :page_size]

  @type t :: %__MODULE__{
          entries: [term()],
          total: non_neg_integer(),
          page: pos_integer(),
          page_size: pos_integer()
        }
end
