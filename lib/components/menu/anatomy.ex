defmodule Corex.Menu.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      close_on_select: true,
      loop_focus: false,
      typeahead: true,
      composite: false,
      value: nil,
      dir: "ltr",
      orientation: "vertical",
      aria_label: nil,
      on_select: nil,
      on_select_client: nil,
      redirect: false,
      on_open_change: nil,
      on_open_change_client: nil,
      positioning: %Corex.Positioning{}
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            close_on_select: boolean(),
            loop_focus: boolean(),
            typeahead: boolean(),
            composite: boolean(),
            value: String.t() | nil,
            dir: String.t(),
            orientation: String.t(),
            aria_label: String.t() | nil,
            on_select: String.t() | nil,
            on_select_client: String.t() | nil,
            redirect: boolean(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            positioning: Corex.Positioning.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs ["data-state", "dir", "data-orientation", "id", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [
      :id,
      disabled: false,
      dir: "ltr",
      orientation: "vertical"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "type",
      "tabindex",
      "aria-expanded",
      "aria-controls",
      "aria-haspopup",
      "aria-disabled",
      "data-disabled",
      "disabled",
      "dir",
      "data-orientation",
      "data-state",
      "id",
      "data-focus",
      "data-placement",
      "data-side"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs ["dir", "data-orientation", "id", "data-state", "data-focus", "aria-hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      :value,
      disabled: false,
      dir: "ltr",
      orientation: "vertical",
      has_nested: false,
      nested_menu_id: nil,
      redirect: nil,
      new_tab: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t(),
            has_nested: boolean(),
            nested_menu_id: String.t() | nil,
            redirect: :href | :patch | :navigate | false | nil,
            new_tab: boolean()
          }

    @ignored_attrs [
      "role",
      "tabindex",
      "aria-disabled",
      "data-disabled",
      "dir",
      "data-orientation",
      "data-state",
      "id",
      "data-focus",
      "data-highlighted",
      "data-ownedby",
      "data-value",
      "aria-checked",
      "aria-expanded",
      "data-placement",
      "data-side"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Group do
    @moduledoc false
    defstruct [
      :id,
      :group_id,
      dir: "ltr",
      orientation: "vertical"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            group_id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "role",
      "dir",
      "data-orientation",
      "id",
      "data-state",
      "data-focus",
      "aria-labelledby"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule GroupLabel do
    @moduledoc false
    defstruct [:id, :group_id, dir: "ltr", orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            group_id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs ["id", "dir", "data-orientation", "data-state", "data-focus", "aria-hidden"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "hidden",
      "dir",
      "data-orientation",
      "id",
      "data-state",
      "style",
      "data-focus",
      "data-placement",
      "data-side"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, dir: "ltr", orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "hidden",
      "role",
      "dir",
      "data-orientation",
      "id",
      "data-state",
      "tabindex",
      "style",
      "data-focus",
      "aria-activedescendant",
      "data-placement",
      "data-side"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
