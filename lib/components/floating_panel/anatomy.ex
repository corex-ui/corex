defmodule Corex.FloatingPanel.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :size,
      :default_position,
      :min_size,
      :max_size,
      draggable: true,
      resizable: true,
      allow_overflow: true,
      close_on_escape: true,
      disabled: false,
      dir: "ltr",
      orientation: "vertical",
      persist_rect: false,
      grid_size: 1,
      on_open_change: nil,
      on_open_change_client: nil,
      on_position_change: nil,
      on_position_change_client: nil,
      on_size_change: nil,
      on_size_change_client: nil,
      on_stage_change: nil,
      on_stage_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            draggable: boolean(),
            resizable: boolean(),
            allow_overflow: boolean(),
            close_on_escape: boolean(),
            disabled: boolean(),
            dir: String.t(),
            orientation: String.t(),
            size: map() | nil,
            default_position: map() | nil,
            min_size: map() | nil,
            max_size: map() | nil,
            persist_rect: boolean(),
            grid_size: number(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            on_position_change: String.t() | nil,
            on_position_change_client: String.t() | nil,
            on_size_change: String.t() | nil,
            on_size_change_client: String.t() | nil,
            on_stage_change: String.t() | nil,
            on_stage_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["data-state", "dir", "data-orientation", "id", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "type",
      "tabindex",
      "dir",
      "data-orientation",
      "data-state",
      "id",
      "data-focus",
      "aria-expanded",
      "aria-controls",
      "disabled",
      "aria-disabled"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "dir",
      "data-orientation",
      "id",
      "data-state",
      "style",
      "data-focus",
      "hidden"
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
      "hidden",
      "dir",
      "data-orientation",
      "id",
      "data-state",
      "style",
      "data-focus",
      "role",
      "tabindex",
      "data-placement",
      "data-side"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Title do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir", "data-orientation", "data-state", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Header do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir", "data-orientation", "data-state", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Body do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir", "data-orientation", "data-state", "data-focus"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule DragTrigger do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "data-state",
      "data-focus",
      "tabindex",
      "role"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule ResizeTrigger do
    @moduledoc false
    defstruct [:id, :axis, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            axis: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "id",
      "dir",
      "data-orientation",
      "data-state",
      "data-focus",
      "data-axis",
      "role",
      "tabindex"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule CloseTrigger do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs [
      "type",
      "tabindex",
      "id",
      "dir",
      "data-orientation",
      "data-state",
      "data-focus",
      "aria-label"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), orientation: String.t()}

    @ignored_attrs ["id", "dir", "data-orientation", "data-state", "data-focus", "role"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule StageTrigger do
    @moduledoc false
    defstruct [:id, :stage, :dir, orientation: "vertical"]

    @type t :: %__MODULE__{
            id: String.t(),
            stage: String.t(),
            dir: String.t(),
            orientation: String.t()
          }

    @ignored_attrs [
      "type",
      "tabindex",
      "id",
      "dir",
      "data-orientation",
      "data-state",
      "data-focus",
      "data-stage",
      "aria-label",
      "aria-pressed",
      "disabled"
    ]
    def ignored_attrs, do: @ignored_attrs
  end
end
