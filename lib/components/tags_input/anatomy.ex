defmodule Corex.TagsInput.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false

    @enforce_keys [:id]

    defstruct [
      :id,
      value: [],
      controlled: false,
      disabled: false,
      read_only: false,
      invalid: false,
      required: false,
      name: nil,
      form: nil,
      dir: "ltr",
      max: nil,
      delimiter: nil,
      blur_behavior: nil,
      add_on_paste: false,
      allow_duplicates: false,
      allow_overflow: false,
      editable: nil,
      auto_focus: false,
      on_value_change: nil,
      on_value_change_client: nil,
      on_input_value_change: nil,
      on_input_value_change_client: nil,
      on_highlight_change: nil,
      on_highlight_change_client: nil,
      on_value_invalid: nil,
      on_value_invalid_client: nil,
      translation: nil,
      submit_name: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: list(String.t()),
            controlled: boolean(),
            disabled: boolean(),
            read_only: boolean(),
            invalid: boolean(),
            required: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            dir: String.t(),
            max: pos_integer() | nil,
            delimiter: String.t() | nil,
            blur_behavior: String.t() | nil,
            add_on_paste: boolean(),
            allow_duplicates: boolean(),
            allow_overflow: boolean(),
            editable: boolean() | nil,
            auto_focus: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            on_input_value_change: String.t() | nil,
            on_input_value_change_client: String.t() | nil,
            on_highlight_change: String.t() | nil,
            on_highlight_change_client: String.t() | nil,
            on_value_invalid: String.t() | nil,
            on_value_invalid_client: String.t() | nil,
            translation: Corex.TagsInput.Translation.t() | nil,
            submit_name: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false

    defstruct [:id, dir: "ltr", read_only: false]

    @ignored_attrs [
      "data-focus",
      "data-empty",
      "data-invalid",
      "data-readonly",
      "data-disabled",
      "dir",
      "id",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false

    defstruct [:id, dir: "ltr"]

    @ignored_attrs [
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "data-required",
      "dir",
      "id",
      "for",
      "htmlFor",
      "data-focus",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false

    defstruct [:id, dir: "ltr"]

    @ignored_attrs [
      "data-focus",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "dir",
      "id",
      "tabindex",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule MainInput do
    @moduledoc false

    defstruct [:id, dir: "ltr", placeholder: nil]

    @ignored_attrs [
      "data-invalid",
      "data-readonly",
      "data-empty",
      "dir",
      "id",
      "type",
      "disabled",
      "placeholder",
      "maxlength",
      "autocomplete",
      "autocorrect",
      "autocapitalize",
      "enterkeyhint",
      "aria-invalid",
      "value",
      "defaultValue",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover",
      "aria-activedescendant"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenInput do
    @moduledoc false

    defstruct [:id]

    @ignored_attrs [
      "type",
      "hidden",
      "name",
      "form",
      "disabled",
      "readonly",
      "required",
      "id",
      "value",
      "defaultValue",
      "data-focus",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ValueInput do
    @moduledoc false

    defstruct [:id, dir: "ltr"]

    @ignored_attrs [
      "type",
      "id",
      "dir",
      "name",
      "form",
      "value",
      "defaultValue",
      "hidden",
      "aria-hidden",
      "autocomplete",
      "tabindex",
      "data-focus",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SsrItem do
    @moduledoc false

    defstruct [:root_id, :dir, :value, :index, :disabled]

    @type t :: %__MODULE__{
            root_id: String.t(),
            dir: String.t(),
            value: String.t(),
            index: non_neg_integer(),
            disabled: boolean()
          }

    @ignored_attrs [
      "dir",
      "data-value",
      "data-disabled",
      "id"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SsrItemPreview do
    @moduledoc false

    defstruct [:root_id, :dir, :value, :index, :disabled]

    @type t :: %__MODULE__{
            root_id: String.t(),
            dir: String.t(),
            value: String.t(),
            index: non_neg_integer(),
            disabled: boolean()
          }

    @ignored_attrs [
      "id",
      "dir",
      "hidden",
      "data-value",
      "data-disabled",
      "data-highlighted",
      "data-delete-intent"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SsrItemText do
    @moduledoc false

    defstruct [:root_id, :index]

    @type t :: %__MODULE__{root_id: String.t(), index: non_neg_integer()}

    @ignored_attrs [
      "id",
      "dir",
      "data-disabled",
      "data-highlighted"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SsrItemDeleteTrigger do
    @moduledoc false

    defstruct [:root_id, :dir, :value, :index, :disabled, :aria_label]

    @type t :: %__MODULE__{
            root_id: String.t(),
            dir: String.t(),
            value: String.t(),
            index: non_neg_integer(),
            disabled: boolean(),
            aria_label: String.t() | nil
          }

    @ignored_attrs [
      "id",
      "dir",
      "type",
      "disabled",
      "aria-disabled",
      "aria-label",
      "tabindex",
      "data-disabled",
      "data-highlighted"
    ]

    def ignored_attrs, do: @ignored_attrs
  end

  defmodule SsrItemInput do
    @moduledoc false

    defstruct [:root_id, :dir, :value, :index, :disabled, :aria_label]

    @type t :: %__MODULE__{
            root_id: String.t(),
            dir: String.t(),
            value: String.t(),
            index: non_neg_integer(),
            disabled: boolean(),
            aria_label: String.t() | nil
          }

    @ignored_attrs [
      "id",
      "dir",
      "type",
      "hidden",
      "disabled",
      "readonly",
      "aria-label",
      "tabindex",
      "maxlength",
      "maxLength",
      "value",
      "defaultValue",
      "style",
      "autocomplete",
      "autocorrect",
      "autocapitalize",
      "inputmode"
    ]

    def ignored_attrs, do: @ignored_attrs
  end
end
