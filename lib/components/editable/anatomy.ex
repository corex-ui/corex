defmodule Corex.Editable.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: "",
      disabled: false,
      read_only: false,
      required: false,
      invalid: false,
      name: nil,
      form: nil,
      dir: "ltr",
      orientation: "horizontal",
      edit: false,
      controlled_edit: false,
      default_edit: false,
      placeholder: nil,
      activation_mode: nil,
      select_on_focus: true,
      on_value_change: nil,
      on_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            disabled: boolean(),
            read_only: boolean(),
            required: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            orientation: String.t(),
            edit: boolean(),
            controlled_edit: boolean(),
            default_edit: boolean(),
            placeholder: String.t() | nil,
            activation_mode: String.t() | nil,
            select_on_focus: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, orientation: "horizontal"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir", "data-orientation"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Area do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      empty: false,
      editing: false,
      auto_resize: true,
      orientation: "horizontal"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            empty: boolean(),
            editing: boolean(),
            auto_resize: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "data-focus",
      "data-disabled",
      "data-placeholder-shown",
      "style"
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
      "data-focus",
      "data-invalid",
      "data-required"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Input do
    @moduledoc false
    defstruct [
      :id,
      :disabled,
      :value,
      :placeholder,
      :name,
      :form,
      :aria_label,
      required: false,
      read_only: false,
      editing: false,
      dir: "ltr",
      orientation: "horizontal"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            value: String.t() | nil,
            placeholder: String.t() | nil,
            name: String.t() | nil,
            form: String.t() | nil,
            aria_label: String.t() | nil,
            required: boolean(),
            read_only: boolean(),
            editing: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "disabled",
      "required",
      "readonly",
      "readOnly",
      "hidden",
      "placeholder",
      "name",
      "form",
      "aria-label",
      "data-disabled",
      "data-readonly",
      "aria-invalid",
      "data-invalid",
      "data-autoresize",
      "defaultValue",
      "value",
      "size",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Preview do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :value_text,
      :aria_label,
      empty: false,
      editing: false,
      orientation: "horizontal"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value_text: String.t() | nil,
            aria_label: String.t() | nil,
            empty: boolean(),
            editing: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "data-placeholder-shown",
      "aria-readonly",
      "data-readonly",
      "data-disabled",
      "aria-disabled",
      "aria-invalid",
      "data-invalid",
      "aria-label",
      "data-autoresize",
      "hidden",
      "tabindex",
      "tabIndex",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule EditTrigger do
    @moduledoc false
    defstruct [:id, :dir, :aria_label, editing: false, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            aria_label: String.t() | nil,
            editing: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "type",
      "hidden",
      "disabled",
      "aria-label"
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

  defmodule Triggers do
    @moduledoc false
    defstruct []

    @type t :: %__MODULE__{}
  end

  defmodule SubmitTrigger do
    @moduledoc false
    defstruct [:id, :dir, :aria_label, editing: false, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            aria_label: String.t() | nil,
            editing: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "type",
      "hidden",
      "disabled",
      "aria-label"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule CancelTrigger do
    @moduledoc false
    defstruct [:id, :dir, :aria_label, editing: false, orientation: "horizontal"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            aria_label: String.t() | nil,
            editing: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "type",
      "hidden",
      "disabled",
      "aria-label"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
