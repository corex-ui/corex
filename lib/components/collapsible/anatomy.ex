defmodule Corex.Collapsible.Anatomy do
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
      on_open_change: nil,
      on_open_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            open: boolean(),
            controlled: boolean(),
            disabled: boolean(),
            dir: String.t(),
            on_open_change: String.t() | nil,
            on_open_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir, :open]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean()
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

  defmodule Content do
    @moduledoc false
    defstruct [:id, :dir, :open, :disabled]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            open: boolean(),
            disabled: boolean()
          }
  end
end
