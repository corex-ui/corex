defmodule Corex.ColorPicker.Anatomy do
  @moduledoc false

  defmodule Root do
    @moduledoc false
    defstruct [:id, :disabled, :invalid, :read_only, :value_style, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            value_style: String.t() | nil,
            dir: String.t()
          }
  end

  defmodule TransparencyGrid do
    @moduledoc false
    defstruct [:size]

    @type t :: %__MODULE__{size: String.t()}
  end

  defmodule Swatch do
    @moduledoc false
    defstruct [:color, :value, :checked]

    @type t :: %__MODULE__{
            color: String.t() | nil,
            value: String.t() | nil,
            checked: boolean() | nil
          }
  end

  defmodule SwatchTrigger do
    @moduledoc false
    defstruct [:value, :checked]

    @type t :: %__MODULE__{value: String.t(), checked: boolean()}
  end

  defmodule PresetSwatch do
    @moduledoc false
    defstruct [:color, :value, :checked]

    @type t :: %__MODULE__{color: String.t() | nil, value: String.t(), checked: boolean()}
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :disabled, :invalid, :read_only, :required, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean()
          }
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :name]

    @type t :: %__MODULE__{id: String.t(), name: String.t() | nil}
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :disabled, :invalid, :read_only, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            open: boolean()
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [
      :id,
      :disabled,
      :invalid,
      :read_only,
      :open,
      :value_str,
      :content_id,
      :label_id,
      :dir
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            open: boolean(),
            value_str: String.t(),
            content_id: String.t(),
            label_id: String.t(),
            dir: String.t()
          }
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :open, :dir]

    @type t :: %__MODULE__{id: String.t(), open: boolean(), dir: String.t()}
  end

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :default_value,
      :value,
      :name,
      :format,
      :default_format,
      controlled: false,
      close_on_select: true,
      default_open: false,
      open: false,
      open_auto_focus: true,
      disabled: false,
      invalid: false,
      read_only: false,
      required: false,
      dir: "ltr",
      positioning: %Corex.Positioning{},
      on_value_change: nil,
      on_value_change_client: nil,
      on_value_change_end: nil,
      on_value_change_end_client: nil,
      on_open_change: nil,
      on_open_change_client: nil,
      on_format_change: nil,
      on_pointer_down_outside: nil,
      on_focus_outside: nil,
      on_interact_outside: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            default_value: String.t() | nil,
            value: String.t() | nil,
            name: String.t() | nil,
            format: String.t(),
            default_format: String.t(),
            controlled: boolean(),
            close_on_select: boolean(),
            default_open: boolean(),
            open: boolean(),
            open_auto_focus: boolean(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean(),
            dir: String.t(),
            positioning: Corex.Positioning.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_value_change_end: String.t() | nil,
            on_value_change_end_client: String.t() | nil,
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            on_format_change: String.t() | nil,
            on_pointer_down_outside: String.t() | nil,
            on_focus_outside: String.t() | nil,
            on_interact_outside: String.t() | nil
          }
  end
end
