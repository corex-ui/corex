defmodule Corex.Collection do
  @moduledoc false

  defmodule Item do
    @moduledoc """
    Collection module. Use it to create a collection of items for the following components:
    - [Combobox](Corex.Combobox.html)
    """

    @derive Jason.Encoder
    @enforce_keys [:id, :label]
    defstruct [
      :id,
      :label,
      disabled: false,
      group: nil,
      meta: %{}
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            label: String.t(),
            disabled: boolean(),
            group: String.t(),
            meta: map()
          }
  end
end
