defmodule Corex.Dialog.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      open: false,
      controlled: false,
      modal: true,
      close_on_interact_outside: true,
      close_on_escape_key_down: true,
      prevent_scroll: false,
      restore_focus: true,
      dir: "ltr",
      on_open_change: nil,
      on_open_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            open: boolean(),
            controlled: boolean(),
            modal: boolean(),
            close_on_interact_outside: boolean(),
            close_on_escape_key_down: boolean(),
            prevent_scroll: boolean(),
            restore_focus: boolean(),
            dir: String.t(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir, :open, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end

  defmodule Backdrop do
    @moduledoc false
    defstruct [:id, :dir, :open, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end

  defmodule Positioner do
    @moduledoc false
    defstruct [:id, :dir, :open, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end

  defmodule Title do
    @moduledoc false
    defstruct [:id, :dir, :open, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end

  defmodule Description do
    @moduledoc false
    defstruct [:id, :dir, :open, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end

  defmodule CloseTrigger do
    @moduledoc false
    defstruct [:id, :dir, :open, changed: false]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            changed: boolean()
          }
  end
end
