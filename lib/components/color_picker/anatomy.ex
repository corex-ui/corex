defmodule Corex.ColorPicker.Anatomy do
  @moduledoc false
end

defmodule Corex.ColorPicker.Anatomy.Root do
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

  @ignored_attrs [
    "id",
    "dir",
    "data-disabled",
    "data-readonly",
    "data-invalid",
    "style",
    "data-state",
    "data-focus"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.TransparencyGrid do
  @moduledoc false
  defstruct [:id, :size, variant: "default"]

  @type t :: %__MODULE__{id: String.t(), size: String.t(), variant: String.t()}

  @ignored_attrs ["id", "data-size", "style", "data-scope", "data-part"]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Swatch do
  @moduledoc false
  defstruct [:id, :color, :value, :checked, variant: "main"]

  @type t :: %__MODULE__{
          id: String.t(),
          color: String.t() | nil,
          value: String.t() | nil,
          checked: boolean() | nil,
          variant: String.t() | nil
        }

  @ignored_attrs [
    "id",
    "style",
    "data-value",
    "data-state",
    "data-scope",
    "data-part",
    "data-checked"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.SwatchTrigger do
  @moduledoc false
  defstruct [:id, :value, :checked, index: 0]

  @type t :: %__MODULE__{
          id: String.t(),
          value: String.t(),
          checked: boolean(),
          index: non_neg_integer()
        }

  @ignored_attrs [
    "id",
    "type",
    "style",
    "data-value",
    "data-state",
    "aria-label",
    "data-scope",
    "data-part"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.PresetSwatch do
  @moduledoc false
  defstruct [:id, :color, :value, :checked, index: 0]

  @type t :: %__MODULE__{
          id: String.t(),
          color: String.t() | nil,
          value: String.t(),
          checked: boolean(),
          index: non_neg_integer()
        }

  @ignored_attrs [
    "id",
    "style",
    "data-value",
    "data-state",
    "data-scope",
    "data-part"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Label do
  @moduledoc false
  defstruct [:id, :disabled, :invalid, :read_only, :required, :dir]

  @type t :: %__MODULE__{
          id: String.t(),
          disabled: boolean(),
          invalid: boolean(),
          read_only: boolean(),
          required: boolean()
        }

  @ignored_attrs [
    "id",
    "dir",
    "for",
    "data-disabled",
    "data-readonly",
    "data-invalid",
    "data-required",
    "data-scope",
    "data-part"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.HiddenInput do
  @moduledoc false
  defstruct [:id, :name]

  @type t :: %__MODULE__{id: String.t(), name: String.t() | nil}

  @ignored_attrs ["id", "name", "value", "type", "style", "data-scope", "data-part"]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Control do
  @moduledoc false
  defstruct [:id, :disabled, :invalid, :read_only, :open]

  @type t :: %__MODULE__{
          id: String.t(),
          disabled: boolean(),
          invalid: boolean(),
          read_only: boolean(),
          open: boolean()
        }

  @ignored_attrs [
    "id",
    "data-disabled",
    "data-readonly",
    "data-invalid",
    "data-state",
    "data-scope",
    "data-part"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Trigger do
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

  @ignored_attrs [
    "id",
    "dir",
    "type",
    "style",
    "aria-label",
    "aria-expanded",
    "aria-controls",
    "aria-labelledby",
    "aria-haspopup",
    "data-disabled",
    "data-readonly",
    "data-invalid",
    "data-state",
    "data-scope",
    "data-part"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Positioner do
  @moduledoc false
  defstruct [:id, :dir]

  @type t :: %__MODULE__{id: String.t(), dir: String.t()}

  @ignored_attrs ["id", "dir", "style", "data-state", "hidden", "data-scope", "data-part"]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Content do
  @moduledoc false
  defstruct [:id, :open, :dir]

  @type t :: %__MODULE__{id: String.t(), open: boolean(), dir: String.t()}

  @ignored_attrs [
    "id",
    "dir",
    "hidden",
    "role",
    "tabindex",
    "data-state",
    "style",
    "data-scope",
    "data-part"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Area do
  @moduledoc false
  defstruct [:picker_id, :dir]

  @type t :: %__MODULE__{picker_id: String.t(), dir: String.t()}

  @ignored_attrs [
    "id",
    "dir",
    "data-scope",
    "data-part",
    "style",
    "data-state",
    "data-focus",
    "role"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.AreaBackground do
  @moduledoc false
  defstruct [:picker_id]

  @type t :: %__MODULE__{picker_id: String.t()}

  @ignored_attrs ["id", "data-scope", "data-part", "style", "data-state"]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.AreaThumb do
  @moduledoc false
  defstruct [:picker_id]

  @type t :: %__MODULE__{picker_id: String.t()}

  @ignored_attrs ["id", "data-scope", "data-part", "style", "data-state", "data-focus", "role"]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.SwatchGroup do
  @moduledoc false
  defstruct [:picker_id]

  @type t :: %__MODULE__{picker_id: String.t()}

  @ignored_attrs ["id", "data-scope", "data-part", "dir", "style", "data-state", "role"]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.ChannelInput do
  @moduledoc false
  defstruct [:picker_id, :qualifier, :channel]

  @type t :: %__MODULE__{picker_id: String.t(), qualifier: String.t(), channel: String.t()}

  @ignored_attrs [
    "id",
    "value",
    "name",
    "style",
    "aria-label",
    "data-channel",
    "type",
    "tabindex",
    "role",
    "readonly",
    "disabled",
    "placeholder",
    "data-scope",
    "data-part",
    "data-state",
    "data-invalid",
    "data-readonly",
    "data-disabled"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.ChannelSlider do
  @moduledoc false
  defstruct [:picker_id, :channel]

  @type t :: %__MODULE__{picker_id: String.t(), channel: String.t()}

  @ignored_attrs [
    "id",
    "data-channel",
    "data-scope",
    "data-part",
    "style",
    "data-state",
    "data-focus",
    "dir",
    "role",
    "tabindex"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.ChannelSliderTrack do
  @moduledoc false
  defstruct [:picker_id, :channel]

  @type t :: %__MODULE__{picker_id: String.t(), channel: String.t()}

  @ignored_attrs ["id", "data-channel", "data-scope", "data-part", "style", "data-state"]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.ChannelSliderThumb do
  @moduledoc false
  defstruct [:picker_id, :channel]

  @type t :: %__MODULE__{picker_id: String.t(), channel: String.t()}

  @ignored_attrs [
    "id",
    "data-channel",
    "data-scope",
    "data-part",
    "style",
    "data-state",
    "data-focus",
    "role"
  ]
  def ignored_attrs, do: @ignored_attrs
end

defmodule Corex.ColorPicker.Anatomy.Props do
  @moduledoc false
  @enforce_keys [:id]

  defstruct [
    :id,
    :value,
    :name,
    form_field: false,
    close_on_select: true,
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
    on_format_change_client: nil,
    on_pointer_down_outside: nil,
    on_pointer_down_outside_client: nil,
    on_focus_outside: nil,
    on_focus_outside_client: nil,
    on_interact_outside: nil,
    on_interact_outside_client: nil
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          form_field: boolean(),
          value: String.t() | nil,
          name: String.t() | nil,
          close_on_select: boolean(),
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
          on_format_change_client: String.t() | nil,
          on_pointer_down_outside: String.t() | nil,
          on_pointer_down_outside_client: String.t() | nil,
          on_focus_outside: String.t() | nil,
          on_focus_outside_client: String.t() | nil,
          on_interact_outside: String.t() | nil,
          on_interact_outside_client: String.t() | nil
        }
end
