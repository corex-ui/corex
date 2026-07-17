defmodule Corex.Combobox.Anatomy do
  @moduledoc false
  alias Corex.Tree

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      items: [],
      items_json: nil,
      placeholder: nil,
      value: [],
      form_field: false,
      controlled: false,
      always_submit_on_enter: false,
      auto_focus: false,
      close_on_select: true,
      dir: "ltr",
      orientation: "vertical",
      input_behavior: "autohighlight",
      loop_focus: false,
      multiple: false,
      invalid: false,
      disabled: false,
      name: nil,
      form: nil,
      read_only: false,
      required: false,
      positioning: %Corex.Positioning{},
      on_open_change: nil,
      on_open_change_client: nil,
      on_input_value_change: nil,
      on_input_value_change_client: nil,
      on_value_change: nil,
      on_value_change_client: nil,
      filter: true,
      redirect: false,
      submit_name: nil,
      allow_custom_value: false,
      selection_behavior: "replace",
      clear_on_empty: false,
      open_on_click: nil,
      open_on_change: nil,
      open_on_key_press: nil,
      composite: nil,
      disable_layer: nil,
      on_highlight_change: nil,
      on_highlight_change_client: nil,
      on_select: nil,
      on_select_client: nil,
      translation: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            items: list(Tree.Item.t() | map()),
            items_json: String.t() | nil,
            placeholder: String.t() | nil,
            value: list(String.t()),
            always_submit_on_enter: boolean(),
            auto_focus: boolean(),
            close_on_select: boolean(),
            dir: String.t(),
            orientation: String.t(),
            input_behavior: String.t(),
            loop_focus: boolean(),
            multiple: boolean(),
            invalid: boolean(),
            disabled: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            read_only: boolean(),
            required: boolean(),
            positioning: Corex.Positioning.t(),
            on_open_change: nil,
            on_open_change_client: nil,
            on_input_value_change: nil,
            on_input_value_change_client: nil,
            on_value_change: nil,
            on_value_change_client: nil,
            filter: boolean(),
            redirect: boolean(),
            form_field: boolean(),
            submit_name: String.t() | nil,
            allow_custom_value: boolean(),
            selection_behavior: String.t(),
            clear_on_empty: boolean(),
            open_on_click: boolean() | nil,
            open_on_change: boolean() | nil,
            open_on_key_press: boolean() | nil,
            composite: boolean() | nil,
            disable_layer: boolean() | nil,
            on_highlight_change: String.t() | nil,
            on_highlight_change_client: String.t() | nil,
            on_select: String.t() | nil,
            on_select_client: String.t() | nil,
            translation: Corex.Combobox.Translation.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, invalid: false, read_only: false, orientation: "vertical", dir: "ltr"]

    @type t :: %__MODULE__{
            id: String.t(),
            invalid: boolean(),
            read_only: boolean(),
            orientation: String.t(),
            dir: String.t()
          }

    @ignored_attrs [
      "data-state",
      "dir",
      "id",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [
      :id,
      invalid: false,
      read_only: false,
      required: false,
      disabled: false,
      dir: "ltr",
      orientation: "vertical"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            invalid: boolean(),
            read_only: boolean(),
            required: boolean(),
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "data-required",
      "data-disabled",
      "data-invalid",
      "data-readonly",
      "htmlFor",
      "for",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, :disabled, :invalid, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "data-disabled",
      "data-invalid",
      "data-state",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Input do
    @moduledoc false
    defstruct [
      :id,
      :dir,
      :disabled,
      :invalid,
      :required,
      :placeholder,
      :name,
      :auto_focus,
      :value,
      :selected_label,
      :form,
      orientation: "vertical"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            required: boolean(),
            placeholder: String.t() | nil,
            name: String.t() | nil,
            auto_focus: boolean(),
            value: list(String.t()),
            selected_label: String.t() | nil,
            form: String.t() | nil,
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "value",
      "aria-expanded",
      "aria-controls",
      "aria-autocomplete",
      "aria-activedescendant",
      "aria-labelledby",
      "role",
      "disabled",
      "data-state",
      "data-placement",
      "data-disabled",
      "data-invalid",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover",
      "placeholder",
      "autoFocus",
      "autocomplete",
      "autoCorrect",
      "autoCapitalize",
      "spellCheck"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :disabled, :invalid, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "type",
      "aria-expanded",
      "aria-controls",
      "disabled",
      "data-state",
      "data-disabled",
      "data-invalid",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ClearTrigger do
    @moduledoc false
    defstruct [:id, :dir, :disabled, :invalid, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            disabled: boolean(),
            invalid: boolean(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "type",
      "aria-label",
      "hidden",
      "disabled",
      "data-state",
      "data-disabled",
      "data-invalid",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "style",
      "data-state",
      "data-placement",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "hidden",
      "role",
      "tabindex",
      "aria-labelledby",
      "data-empty",
      "data-state",
      "data-placement",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule List do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "role",
      "tabindex",
      "aria-labelledby",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemGroup do
    @moduledoc false
    defstruct [:id, :group_id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            group_id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "data-id",
      "role",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemGroupLabel do
    @moduledoc false
    defstruct [:id, :html_for, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            html_for: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "role",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [:id, :item, :value, :dir, :orientation, :to, redirect: nil, new_tab: false]

    @type t :: %__MODULE__{
            id: String.t(),
            item: map(),
            value: String.t(),
            dir: String.t(),
            orientation: String.t(),
            to: String.t() | nil,
            redirect: :href | :patch | :navigate | false | nil,
            new_tab: boolean()
          }

    @ignored_attrs [
      "data-value",
      "data-to",
      "data-redirect",
      "data-new-tab",
      "data-state",
      "data-highlighted",
      "data-disabled",
      "dir",
      "id",
      "aria-disabled",
      "aria-selected",
      "role",
      "tabindex",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemText do
    @moduledoc false
    defstruct [:id, :item, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            item: map(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs ["id", "dir", "data-focus", "data-focus-visible"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemIndicator do
    @moduledoc false
    defstruct [:id, :item, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            item: map(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "hidden",
      "aria-hidden",
      "dir",
      "data-state",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Empty do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir"]
    def ignored_attrs, do: @ignored_attrs
  end
end
