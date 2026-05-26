defmodule Corex.NumberInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      form_field: false,
      value: nil,
      min: nil,
      max: nil,
      step: 1,
      disabled: false,
      read_only: false,
      invalid: false,
      required: false,
      allow_mouse_wheel: false,
      name: nil,
      form: nil,
      on_value_change: nil,
      on_value_change_client: nil,
      dir: "ltr",
      orientation: "horizontal"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            form_field: boolean(),
            value: String.t() | nil,
            min: number() | nil,
            max: number() | nil,
            step: number(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean(),
            required: boolean(),
            allow_mouse_wheel: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            dir: String.t(),
            orientation: String.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "horizontal", read_only: false]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "data-scope",
      "data-part",
      "id",
      "dir",
      "data-orientation",
      "data-disabled",
      "data-focus",
      "data-invalid",
      "data-scrubbing"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "data-scope",
      "data-part",
      "id",
      "dir",
      "data-orientation",
      "data-disabled",
      "data-focus",
      "data-invalid",
      "data-required",
      "data-scrubbing",
      "for",
      "htmlFor"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "data-scope",
      "data-part",
      "id",
      "dir",
      "data-orientation",
      "role",
      "aria-disabled",
      "data-focus",
      "data-disabled",
      "data-invalid",
      "data-scrubbing",
      "aria-invalid"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ValueText do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :disabled, required: false, dir: "ltr", orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            required: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-scope",
      "data-part",
      "id",
      "dir",
      "data-orientation",
      "name",
      "form",
      "role",
      "type",
      "disabled",
      "readonly",
      "readOnly",
      "required",
      "inputmode",
      "inputMode",
      "pattern",
      "data-invalid",
      "data-disabled",
      "data-scrubbing",
      "autocomplete",
      "autoComplete",
      "autoCorrect",
      "autocorrect",
      "spellcheck",
      "spellCheck",
      "aria-invalid",
      "aria-roledescription",
      "aria-valuemin",
      "aria-valuemax",
      "aria-valuenow",
      "aria-valuetext",
      "defaultValue",
      "value",
      "style",
      "tabindex",
      "tabIndex"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule TriggerGroup do
    @moduledoc false
    defstruct dir: "ltr", orientation: "horizontal"

    @type t :: %__MODULE__{dir: String.t(), orientation: String.t()}
  end

  defmodule DecrementTrigger do
    @moduledoc false
    defstruct [:id, :aria_label, dir: "ltr", orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            aria_label: String.t() | nil,
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-scope",
      "data-part",
      "id",
      "dir",
      "data-orientation",
      "disabled",
      "data-disabled",
      "aria-label",
      "type",
      "tabindex",
      "tabIndex",
      "aria-controls",
      "data-scrubbing",
      "role"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule IncrementTrigger do
    @moduledoc false
    defstruct [:id, :aria_label, dir: "ltr", orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            aria_label: String.t() | nil,
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-scope",
      "data-part",
      "id",
      "dir",
      "data-orientation",
      "disabled",
      "data-disabled",
      "aria-label",
      "type",
      "tabindex",
      "tabIndex",
      "aria-controls",
      "data-scrubbing",
      "role"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
