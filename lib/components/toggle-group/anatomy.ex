defmodule Corex.ToggleGroup.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: [],
      controlled: false,
      deselectable: false,
      loopFocus: false,
      rovingFocus: false,
      disabled: false,
      multiple: true,
      orientation: "vertical",
      dir: "ltr",
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: list(String.t()),
            controlled: boolean(),
            deselectable: boolean(),
            loopFocus: boolean(),
            rovingFocus: boolean(),
            disabled: boolean(),
            multiple: boolean(),
            orientation: String.t(),
            dir: String.t(),
            on_value_change: String.t(),
            on_value_change_client: String.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, changed: false, orientation: "vertical", dir: "ltr", disabled: false]

    @type t :: %__MODULE__{
            id: String.t(),
            changed: boolean(),
            orientation: String.t(),
            dir: String.t(),
            disabled: boolean()
          }
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      changed: false,
      orientation: "vertical",
      dir: "ltr",
      values: [],
      value: nil,
      disabled: false,
      disabled_root: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            orientation: String.t(),
            dir: String.t(),
            value: String.t() | nil,
            disabled: boolean(),
            changed: boolean(),
            values: list(String.t()),
            disabled_root: boolean()
          }
  end
end
