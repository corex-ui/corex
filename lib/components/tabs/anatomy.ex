defmodule Corex.Tabs.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      value: [],
      controlled: false,
      collapsible: true,
      multiple: true,
      orientation: "vertical",
      dir: "ltr",
      on_value_change: nil,
      on_value_change_client: nil,
      on_focus_change: nil,
      on_focus_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: list(String.t()),
            controlled: boolean(),
            collapsible: boolean(),
            multiple: boolean(),
            orientation: String.t(),
            dir: String.t(),
            on_value_change: String.t(),
            on_value_change_client: String.t(),
            on_focus_change: String.t(),
            on_focus_change_client: String.t()
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, orientation: "vertical", dir: "ltr"]

    @type t :: %__MODULE__{
            id: String.t(),
            orientation: String.t(),
            dir: String.t()
          }

    @ignored_attrs ["data-orientation", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule List do
    @moduledoc false
    defstruct [:id, orientation: "vertical", dir: "ltr"]

    @type t :: %__MODULE__{
            id: String.t(),
            orientation: String.t(),
            dir: String.t()
          }

    @ignored_attrs [
      "data-orientation",
      "dir",
      "id",
      "role",
      "tabindex",
      "aria-label",
      "aria-labelledby",
      "aria-orientation"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [
      :id,
      orientation: "vertical",
      dir: "ltr",
      values: [],
      value: nil,
      disabled: false,
      data: %{}
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            data: map(),
            orientation: String.t(),
            dir: String.t(),
            value: String.t() | nil,
            disabled: boolean(),
            values: list(String.t())
          }

    @ignored_attrs [
      "aria-expanded",
      "aria-selected",
      "aria-disabled",
      "aria-controls",
      "tabindex",
      "data-selected",
      "data-state",
      "data-focus",
      "data-orientation",
      "dir"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Indicator do
    @moduledoc false
    defstruct [:id, values: [], orientation: "vertical", dir: "ltr"]

    @type t :: %__MODULE__{
            id: String.t(),
            values: list(String.t()),
            orientation: String.t(),
            dir: String.t()
          }

    @ignored_attrs [
      "id",
      "aria-hidden",
      "data-state",
      "data-disabled",
      "data-focus",
      "data-orientation",
      "dir",
      "hidden",
      "style"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [
      :id,
      orientation: "vertical",
      dir: "ltr",
      values: [],
      value: nil,
      disabled: false,
      data: %{}
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            data: map(),
            orientation: String.t(),
            dir: String.t(),
            value: String.t() | nil,
            disabled: boolean(),
            values: list(String.t())
          }

    @ignored_attrs [
      "hidden",
      "data-state",
      "data-focus",
      "data-orientation",
      "dir",
      "role",
      "tabindex"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
