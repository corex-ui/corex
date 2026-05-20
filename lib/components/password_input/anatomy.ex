defmodule Corex.PasswordInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      visible: false,
      disabled: false,
      invalid: false,
      read_only: false,
      required: false,
      ignore_password_managers: false,
      name: nil,
      form: nil,
      dir: "ltr",
      orientation: "horizontal",
      auto_complete: "current-password",
      on_visibility_change: nil,
      on_visibility_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            visible: boolean(),
            disabled: boolean(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean(),
            ignore_password_managers: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            orientation: String.t(),
            auto_complete: String.t(),
            on_visibility_change: String.t() | nil,
            on_visibility_change_client: String.t() | nil
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
      "data-disabled",
      "data-invalid",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), orientation: String.t()}

    @ignored_attrs [
      "id",
      "for",
      "htmlFor",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "data-required",
      "data-orientation"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), orientation: String.t()}

    @ignored_attrs [
      "id",
      "data-orientation",
      "data-disabled",
      "data-invalid",
      "data-readonly"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :disabled, :name, :form, :auto_complete, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            auto_complete: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "data-orientation",
      "type",
      "name",
      "form",
      "disabled",
      "readonly",
      "readOnly",
      "required",
      "autocomplete",
      "autoComplete",
      "spellcheck",
      "spellCheck",
      "autocapitalize",
      "autoCapitalize",
      "data-state",
      "aria-invalid",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "data-1p-ignore",
      "data-lpignore",
      "data-bwignore",
      "data-form-type",
      "data-protonpass-ignore"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule VisibilityTrigger do
    @moduledoc false
    defstruct [:id, :aria_label, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            aria_label: String.t() | nil,
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "data-orientation",
      "type",
      "tabIndex",
      "aria-controls",
      "aria-expanded",
      "data-readonly",
      "disabled",
      "data-disabled",
      "data-state",
      "aria-label",
      "role"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, :visible, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            visible: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "aria-hidden",
      "data-state",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "data-orientation"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
