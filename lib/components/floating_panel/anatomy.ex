defmodule Corex.FloatingPanel.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :size,
      :default_size,
      :position,
      :default_position,
      :min_size,
      :max_size,
      open: false,
      default_open: false,
      controlled: false,
      draggable: true,
      resizable: true,
      allow_overflow: true,
      close_on_escape: true,
      disabled: false,
      dir: "ltr",
      persist_rect: false,
      grid_size: 1,
      on_open_change: nil,
      on_open_change_client: nil,
      on_position_change: nil,
      on_size_change: nil,
      on_stage_change: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            open: boolean(),
            default_open: boolean(),
            controlled: boolean(),
            draggable: boolean(),
            resizable: boolean(),
            allow_overflow: boolean(),
            close_on_escape: boolean(),
            disabled: boolean(),
            dir: String.t(),
            size: map() | nil,
            default_size: map() | nil,
            position: map() | nil,
            default_position: map() | nil,
            min_size: map() | nil,
            max_size: map() | nil,
            persist_rect: boolean(),
            grid_size: number(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil,
            on_position_change: String.t() | nil,
            on_size_change: String.t() | nil,
            on_stage_change: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{id: String.t(), dir: String.t()}
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Title do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Header do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Body do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule DragTrigger do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule ResizeTrigger do
    @moduledoc false
    defstruct [:id, :axis]

    @type t :: %__MODULE__{id: String.t(), axis: String.t()}
  end

  defmodule CloseTrigger do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule StageTrigger do
    @moduledoc false
    defstruct [:id, :stage]

    @type t :: %__MODULE__{id: String.t(), stage: String.t()}
  end
end
