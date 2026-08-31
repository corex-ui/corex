defmodule Corex.RatingGroup.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]
    defstruct [
      :id,
      dir: "ltr",
      name: nil,
      count: 5,
      value: 0,
      allow_half: false,
      disabled: false,
      read_only: false,
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            name: String.t() | nil,
            count: integer(),
            value: number(),
            allow_half: boolean(),
            disabled: boolean(),
            read_only: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]
    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end
end
