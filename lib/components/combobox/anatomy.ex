defmodule Corex.Combobox.Anatomy do
  @moduledoc false
  alias Corex.Collection

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      collection: [],
      controlled: false,
      placeholder: nil,
      open: false,
      value: [],
      always_submit_on_enter: false,
      auto_focus: false,
      close_on_select: false,
      dir: "ltr",
      input_behavior: "autohighlight",
      loop_focus: false,
      multiple: false,
      invalid: false,
      disabled: false,
      name: nil,
      read_only: false,
      required: false,
      hide_when_detached: false,
      strategy: "absolute",
      placement: "bottom",
      offset_main_axis: 0,
      offset_cross_axis: 0,
      gutter: 0,
      shift: 0,
      overflow_padding: 0,
      flip: true,
      slide: true,
      overlap: true,
      same_width: true,
      fit_viewport: true,
      on_open_change: nil,
      on_open_change_client: nil,
      on_input_value_change: nil,
      on_value_change: nil,
      bubble: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            collection: list(Collection.Item.t() | map()),
            controlled: boolean(),
            placeholder: String.t() | nil,
            value: list(String.t()),
            always_submit_on_enter: boolean(),
            auto_focus: boolean(),
            close_on_select: boolean(),
            dir: String.t(),
            input_behavior: String.t(),
            loop_focus: boolean(),
            multiple: boolean(),
            invalid: boolean(),
            disabled: boolean(),
            name: String.t() | nil,
            read_only: boolean(),
            required: boolean(),
            hide_when_detached: boolean(),
            strategy: String.t(),
            placement: String.t(),
            offset_main_axis: integer(),
            offset_cross_axis: integer(),
            gutter: integer(),
            shift: integer(),
            overflow_padding: integer(),
            flip: boolean(),
            slide: boolean(),
            overlap: boolean(),
            same_width: boolean(),
            fit_viewport: boolean(),
            same_width: boolean(),
            fit_viewport: boolean(),
            on_open_change: (map() -> any()) | nil,
            on_open_change_client: (map() -> any()) | nil,
            on_input_value_change: (map() -> any()) | nil,
            on_value_change: (map() -> any()) | nil,
            open: boolean() | nil,
            bubble: boolean()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, changed: false, invalid: false, read_only: false]

    @type t :: %__MODULE__{
            id: String.t(),
            changed: boolean(),
            invalid: boolean(),
            read_only: boolean()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [
      :id,
      changed: false,
      invalid: false,
      read_only: false,
      required: false,
      disabled: false,
      dir: "ltr"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            changed: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean(),
            disabled: boolean(),
            dir: String.t()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, :disabled, :changed, :invalid, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            changed: boolean(),
            invalid: boolean(),
            open: boolean()
          }
  end

  defmodule Input do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :disabled,
      :changed,
      :invalid,
      :open,
      :required,
      :placeholder,
      :name,
      :auto_focus
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            changed: boolean(),
            invalid: boolean(),
            open: boolean(),
            required: boolean(),
            placeholder: String.t() | nil,
            name: String.t() | nil,
            auto_focus: boolean()
          }
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, :changed]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            changed: boolean()
          }
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open, :changed]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end
end
