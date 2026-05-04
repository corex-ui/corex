defmodule Corex.RadioGroup.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: nil,
      controlled: false,
      name: nil,
      form: nil,
      disabled: false,
      invalid: false,
      required: false,
      read_only: false,
      dir: "ltr",
      orientation: "vertical",
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            controlled: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            disabled: boolean(),
            invalid: boolean(),
            required: boolean(),
            read_only: boolean(),
            dir: String.t(),
            orientation: String.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :orientation, :has_label]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t(),
            has_label: boolean()
          }

    @ignored_attrs [
      "data-state",
      "data-orientation",
      "dir",
      "id",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover",
      "aria-labelledby"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "data-disabled",
      "data-invalid",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["data-orientation", "dir", "id", "hidden", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid, :checked, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            checked: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-state",
      "data-value",
      "data-disabled",
      "data-invalid",
      "data-orientation",
      "dir",
      "id",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover",
      "aria-checked",
      "tabindex",
      "role"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemText do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-disabled",
      "data-invalid",
      "data-orientation",
      "dir",
      "id",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemControl do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid, :checked, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            checked: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-state",
      "data-value",
      "data-disabled",
      "data-invalid",
      "data-orientation",
      "dir",
      "id",
      "data-focus",
      "data-focus-visible",
      "aria-hidden"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemHiddenInput do
    @moduledoc false
    defstruct [:id, :value, :disabled, :invalid, :name, :form, :checked, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            checked: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "checked",
      "disabled",
      "data-value",
      "data-disabled",
      "data-invalid",
      "data-orientation",
      "dir",
      "id",
      "aria-checked",
      "data-focus",
      "data-focus-visible",
      "data-state",
      "tabindex"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
