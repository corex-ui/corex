defmodule Corex.Drawer.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      dir: "ltr",
      modal: true,
      trap_focus: true,
      prevent_scroll: true,
      close_on_interact_outside: true,
      close_on_escape: true,
      swipe_direction: "down",
      snap_points: nil,
      default_snap_point: nil,
      prevent_drag_on_scroll: true,
      on_open_change: nil,
      on_open_change_client: nil,
      on_snap_point_change: nil,
      on_snap_point_change_client: nil,
      on_trigger_value_change: nil,
      on_trigger_value_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            modal: boolean(),
            trap_focus: boolean(),
            prevent_scroll: boolean(),
            close_on_interact_outside: boolean(),
            close_on_escape: boolean(),
            swipe_direction: String.t(),
            snap_points: String.t() | nil,
            default_snap_point: String.t() | nil,
            prevent_drag_on_scroll: boolean(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            on_snap_point_change: String.t() | nil,
            on_snap_point_change_client: String.t() | nil,
            on_trigger_value_change: String.t() | nil,
            on_trigger_value_change_client: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open, value: nil]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean() | nil,
            value: term()
          }

    @ignored_attrs [
      "type",
      "dir",
      "data-state",
      "id",
      "data-value",
      "data-current",
      "aria-expanded"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Backdrop do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), open: boolean() | nil}

    @ignored_attrs ["dir", "data-state", "id", "hidden", "aria-hidden", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), open: boolean() | nil}

    @ignored_attrs ["dir", "id", "data-state", "style"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{id: String.t(), dir: String.t(), open: boolean() | nil}

    @ignored_attrs [
      "dir",
      "data-state",
      "id",
      "role",
      "hidden",
      "aria-hidden",
      "style",
      "data-expanded",
      "data-dragging"
    ]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Title do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Description do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule CloseTrigger do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["type", "dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule Grabber do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end

  defmodule GrabberIndicator do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}

    @ignored_attrs ["dir", "id"]
    def ignored_attrs, do: @ignored_attrs
  end
end
