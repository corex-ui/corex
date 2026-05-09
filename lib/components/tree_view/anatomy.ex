defmodule Corex.TreeView.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :tree,
      value: [],
      expanded_value: [],
      controlled: false,
      selection_mode: "single",
      redirect: false,
      typeahead: true,
      dir: "ltr",
      on_selection_change: nil,
      on_selection_change_client: nil,
      on_expanded_change: nil,
      on_expanded_change_client: nil,
      animation: "js",
      animation_options: %Corex.Animation.Height{}
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            tree: map() | nil,
            value: list(String.t()),
            expanded_value: list(String.t()),
            controlled: boolean(),
            selection_mode: String.t(),
            redirect: boolean(),
            typeahead: boolean(),
            dir: String.t(),
            on_selection_change: String.t() | nil,
            on_selection_change_client: String.t() | nil,
            on_expanded_change: String.t() | nil,
            on_expanded_change_client: String.t() | nil,
            animation: String.t(),
            animation_options: Corex.Animation.Height.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, dir: "ltr"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, dir: "ltr"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Tree do
    @moduledoc false

    @ignored_attrs [
      "dir",
      "id",
      "role",
      "tabindex",
      "aria-label",
      "aria-labelledby",
      "aria-activedescendant"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Item do
    @moduledoc false
    defstruct [
      :id,
      :value,
      :to,
      :index_path,
      :name,
      dir: "ltr",
      disabled: false,
      data: %{},
      redirect: nil,
      new_tab: false,
      selected: false,
      focused: false
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            to: String.t() | nil,
            index_path: list(integer()),
            name: String.t() | nil,
            dir: String.t(),
            disabled: boolean(),
            data: map(),
            redirect: :href | :patch | :navigate | false | nil,
            new_tab: boolean(),
            selected: boolean(),
            focused: boolean()
          }

    @ignored_attrs [
      "dir",
      "id",
      "style",
      "role",
      "tabindex",
      "aria-selected",
      "aria-current",
      "aria-level",
      "aria-expanded",
      "aria-disabled",
      "data-state",
      "data-focus",
      "data-selected",
      "data-ownedby"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Branch do
    @moduledoc false
    defstruct [
      :id,
      :value,
      :index_path,
      :name,
      dir: "ltr",
      disabled: false,
      data: %{},
      expanded: false,
      selected: false,
      focused: false,
      animation: "js"
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t(),
            index_path: list(integer()),
            name: String.t() | nil,
            dir: String.t(),
            disabled: boolean(),
            data: map(),
            expanded: boolean(),
            selected: boolean(),
            focused: boolean(),
            animation: String.t()
          }

    @ignored_attrs [
      "dir",
      "id",
      "style",
      "data-state",
      "data-focus",
      "data-selected",
      "role",
      "tabindex",
      "aria-expanded",
      "aria-selected",
      "aria-disabled",
      "aria-level",
      "aria-controls",
      "aria-labelledby"
    ]
    def ignored_attrs, do: @ignored_attrs

    def with_animation(%__MODULE__{} = b, animation) when is_binary(animation) do
      struct!(b, %{animation: animation})
    end

    def with_animation(m, animation) when is_map(m) and is_binary(animation) do
      struct!(__MODULE__, Map.put(m, :animation, animation))
    end
  end

  defmodule BranchControl do
    @moduledoc false

    @ignored_attrs [
      "dir",
      "id",
      "style",
      "data-state",
      "data-focus",
      "data-selected",
      "role",
      "tabindex",
      "aria-expanded",
      "aria-selected",
      "aria-disabled",
      "aria-level",
      "aria-controls",
      "aria-labelledby"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule BranchContent do
    @moduledoc false

    @ignored_attrs [
      "dir",
      "id",
      "data-state",
      "hidden",
      "style",
      "role"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule BranchIndicator do
    @moduledoc false

    @ignored_attrs [
      "dir",
      "id",
      "data-state",
      "data-disabled",
      "data-focus",
      "aria-hidden"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule BranchText do
    @moduledoc false

    @ignored_attrs ["dir", "id", "data-value", "data-path"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemText do
    @moduledoc false

    @ignored_attrs ["dir", "id", "data-value", "data-path"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ItemIndicator do
    @moduledoc false

    @ignored_attrs [
      "dir",
      "id",
      "hidden",
      "data-state",
      "data-disabled",
      "data-selected",
      "data-focus",
      "aria-hidden"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule BranchIndentGuide do
    @moduledoc false

    @ignored_attrs ["dir", "id", "data-value", "data-path", "data-depth"]
    def ignored_attrs, do: @ignored_attrs
  end
end
