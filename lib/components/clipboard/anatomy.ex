defmodule Corex.Clipboard.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      :value,
      :timeout,
      :trigger_aria_label,
      :input_aria_label,
      controlled: false,
      dir: "ltr",
      on_copy: nil,
      on_copy_client: nil,
      on_value_change: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            value: String.t() | nil,
            timeout: integer() | nil,
            controlled: boolean(),
            dir: String.t(),
            on_copy: String.t() | nil,
            on_copy_client: String.t() | nil,
            on_value_change: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Label do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end

  defmodule Input do
    @moduledoc false
    defstruct [:id, :dir, :value]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t(),
            value: String.t() | nil
          }
  end

  defmodule Trigger do
    @moduledoc false
    defstruct [:id, :dir]

    @type t :: %__MODULE__{
            id: String.t(),
            dir: String.t()
          }
  end
end
