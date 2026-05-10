defmodule Corex.Listbox.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      items: [],
      value: [],
      controlled: false,
      disabled: false,
      dir: "ltr",
      orientation: "vertical",
      loop_focus: false,
      selection_mode: "single",
      select_on_highlight: false,
      deselectable: false,
      typeahead: false,
      on_value_change: nil,
      on_value_change_client: nil,
      redirect: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            items: list(map()),
            value: list(String.t()),
            controlled: boolean(),
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t(),
            loop_focus: boolean(),
            selection_mode: String.t(),
            select_on_highlight: boolean(),
            deselectable: boolean(),
            typeahead: boolean(),
            on_value_change: String.t() | nil,
            on_value_change_client: String.t() | nil,
            redirect: boolean()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "data-state",
      "data-orientation",
      "dir",
      "id",
      "data-disabled",
      "data-focus",
      "data-focus-visible",
      "data-active",
      "data-hover"
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
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :orientation]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "data-layout",
      "aria-labelledby",
      "tabindex",
      "data-disabled",
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
      "data-orientation",
      "dir",
      "id",
      "data-id",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemGroupLabel do
    @moduledoc false
    defstruct [:id, :html_for, :dir, :orientation]

    @type t :: %__MODULE__{
            id: String.t(),
            html_for: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs ["id", "data-orientation", "dir", "data-focus", "data-focus-visible"]
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
      "data-orientation",
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
    defstruct [:id, :item, :orientation]

    @type t :: %__MODULE__{id: String.t(), item: map(), orientation: String.t()}

    @ignored_attrs ["id", "data-orientation", "data-focus", "data-focus-visible"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemIndicator do
    @moduledoc false
    defstruct [:id, :item, :dir, :orientation]

    @type t :: %__MODULE__{id: String.t(), item: map(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "id",
      "hidden",
      "data-state",
      "data-focus",
      "data-focus-visible"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
