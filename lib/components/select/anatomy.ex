defmodule Corex.Select.Anatomy do
  @moduledoc false
  alias Corex.Tree

  defmodule Props do
    @moduledoc false
    alias Corex.Tree
    @enforce_keys [:id]

    defstruct [
      :id,
      items: [],
      placeholder: nil,
      value: [],
      controlled: false,
      disabled: false,
      close_on_select: true,
      dir: "ltr",
      orientation: "vertical",
      loop_focus: false,
      multiple: false,
      invalid: false,
      name: nil,
      form: nil,
      read_only: false,
      required: false,
      on_value_change: nil,
      on_value_change_client: nil,
      redirect: false,
      positioning: nil,
      deselectable: false,
      update_trigger: true
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            items: list(Tree.Item.t() | map()),
            placeholder: String.t() | nil,
            value: list(String.t()),
            controlled: boolean(),
            disabled: boolean(),
            close_on_select: boolean(),
            dir: String.t(),
            orientation: String.t(),
            loop_focus: boolean(),
            multiple: boolean(),
            invalid: boolean(),
            name: String.t() | nil,
            form: String.t() | nil,
            read_only: boolean(),
            required: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            redirect: boolean(),
            positioning: Corex.Positioning.t() | nil,
            deselectable: boolean(),
            update_trigger: boolean()
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
      "data-orientation",
      "dir",
      "id",
      "data-disabled",
      "data-readonly",
      "data-invalid",
      "data-open",
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
      "data-orientation",
      "dir",
      "id",
      "data-required",
      "data-disabled",
      "data-invalid",
      "data-readonly",
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
      "data-orientation",
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
      "data-orientation",
      "dir",
      "id",
      "type",
      "aria-expanded",
      "aria-controls",
      "aria-haspopup",
      "aria-labelledby",
      "aria-label",
      "disabled",
      "data-state",
      "data-placement",
      "data-disabled",
      "data-invalid",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "style",
      "data-state",
      "data-placement",
      "data-disabled",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "hidden",
      "role",
      "tabindex",
      "aria-labelledby",
      "aria-multiselectable",
      "data-state",
      "data-placement",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule HiddenSelect do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "multiple",
      "name",
      "form",
      "aria-hidden",
      "tabindex",
      "data-state",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ValueInput do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "value",
      "data-orientation",
      "dir",
      "name",
      "form",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemGroup do
    @moduledoc false
    defstruct [:id, :group_id, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            group_id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "data-id",
      "data-orientation",
      "dir",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemGroupLabel do
    @moduledoc false
    defstruct [:id, :group_id, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            group_id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "data-id",
      "data-orientation",
      "dir",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      :value,
      :dir,
      :orientation,
      :to,
      redirect: nil,
      new_tab: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            dir: String.t(),
            orientation: String.t(),
            to: String.t() | nil,
            redirect: :href | :patch | :navigate | false | nil,
            new_tab: boolean()
          }

    @ignored_attrs [
      "data-value",
      "data-state",
      "data-highlighted",
      "data-disabled",
      "data-orientation",
      "dir",
      "id",
      "role",
      "tabindex",
      "aria-selected",
      "aria-checked",
      "aria-disabled",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemText do
    @moduledoc false
    defstruct [:id, :value, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs ["id", "data-orientation", "dir", "data-focus", "data-focus-visible"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemIndicator do
    @moduledoc false
    defstruct [:id, :value, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "data-orientation",
      "dir",
      "data-state",
      "hidden",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
