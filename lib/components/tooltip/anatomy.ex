defmodule Corex.Tooltip.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      open: false,
      controlled: false,
      disabled: false,
      dir: "ltr",
      open_delay: nil,
      close_delay: nil,
      placement: nil,
      close_on_escape: nil,
      close_on_click: nil,
      close_on_pointer_down: nil,
      close_on_scroll: nil,
      interactive: false,
      on_open_change: nil,
      on_open_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            open: boolean(),
            controlled: boolean(),
            disabled: boolean(),
            dir: String.t(),
            open_delay: non_neg_integer() | nil,
            close_delay: non_neg_integer() | nil,
            placement: String.t() | nil,
            close_on_escape: boolean() | nil,
            close_on_click: boolean() | nil,
            close_on_pointer_down: boolean() | nil,
            close_on_scroll: boolean() | nil,
            interactive: boolean(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open, :disabled]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            disabled: boolean()
          }
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
          }
  end

  defmodule Arrow do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule ArrowTip do
    @moduledoc false
    defstruct [:dir]

    @type t :: %__MODULE__{dir: String.t()}
  end
end
