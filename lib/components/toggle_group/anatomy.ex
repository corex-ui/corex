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
    defstruct [:id, orientation: "vertical", dir: "ltr", disabled: false, aria_labelledby: nil]

    @type t :: %__MODULE__{
            id: String.t(),
            orientation: String.t(),
            dir: String.t(),
            disabled: boolean(),
            aria_labelledby: String.t() | nil
          }

    @ignored_attrs [
      "data-state",
      "data-orientation",
      "dir",
      "id",
      "data-disabled",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      orientation: "vertical",
      dir: "ltr",
      values: [],
      value: nil,
      disabled: false,
      disabled_root: false,
      aria_label: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            orientation: String.t(),
            dir: String.t(),
            value: String.t() | nil,
            disabled: boolean(),
            values: list(String.t()),
            disabled_root: boolean(),
            aria_label: String.t() | nil
          }

    @ignored_attrs [
      "data-state",
      "data-value",
      "data-orientation",
      "dir",
      "id",
      "type",
      "disabled",
      "data-disabled",
      "data-ownedby",
      "aria-label",
      "aria-pressed",
      "tabindex",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
