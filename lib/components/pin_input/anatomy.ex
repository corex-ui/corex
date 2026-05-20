defmodule Corex.PinInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: [],
      count: 4,
      disabled: false,
      invalid: false,
      required: false,
      read_only: false,
      mask: false,
      otp: false,
      blur_on_complete: false,
      select_on_focus: false,
      name: nil,
      form: nil,
      dir: "ltr",
      orientation: "horizontal",
      type: "numeric",
      placeholder: "○",
      on_value_change: nil,
      on_value_change_client: nil,
      on_value_complete: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: list(String.t()),
            count: non_neg_integer(),
            disabled: boolean(),
            invalid: boolean(),
            required: boolean(),
            read_only: boolean(),
            mask: boolean(),
            otp: boolean(),
            blur_on_complete: boolean(),
            select_on_focus: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            orientation: String.t(),
            type: String.t(),
            placeholder: String.t(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_value_complete: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal", read_only: false]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "data-invalid",
      "data-disabled",
      "data-complete",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "for",
      "htmlFor",
      "data-invalid",
      "data-disabled",
      "data-complete",
      "data-required",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false
    defstruct [:id, :name, :value]

    @type t :: %__MODULE__{id: String.t(), name: String.t() | nil, value: String.t()}

    @ignored_attrs [
      "id",
      "name",
      "value",
      "type",
      "disabled",
      "readonly",
      "readOnly",
      "required",
      "form",
      "tabIndex",
      "maxLength",
      "aria-hidden",
      "style",
      "defaultValue"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir", "data-orientation"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :index, :aria_label, :dir, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            index: non_neg_integer(),
            aria_label: String.t() | nil,
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "disabled",
      "tabIndex",
      "data-disabled",
      "data-complete",
      "data-filled",
      "data-index",
      "data-ownedby",
      "aria-label",
      "inputmode",
      "inputMode",
      "aria-invalid",
      "data-invalid",
      "enterkeyhint",
      "enterKeyHint",
      "type",
      "defaultValue",
      "readonly",
      "readOnly",
      "autocomplete",
      "autoComplete",
      "autocapitalize",
      "autoCapitalize",
      "placeholder"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
