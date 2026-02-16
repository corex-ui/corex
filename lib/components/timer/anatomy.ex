defmodule Corex.Timer.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      countdown: false,
      start_ms: 0,
      target_ms: nil,
      auto_start: false,
      interval: 1000,
      on_tick: nil,
      on_complete: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            countdown: boolean(),
            start_ms: non_neg_integer(),
            target_ms: non_neg_integer() | nil,
            auto_start: boolean(),
            interval: non_neg_integer(),
            on_tick: String.t() | nil,
            on_complete: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Area do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Control do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Item do
    @moduledoc false
    defstruct [:id, :type, :value]

    @type t :: %__MODULE__{id: String.t(), type: String.t(), value: non_neg_integer()}
  end

  defmodule Separator do
    @moduledoc false
    defstruct []

    @type t :: %__MODULE__{}
  end

  defmodule ActionTrigger do
    @moduledoc false
    defstruct [:action, hidden: false]

    @type t :: %__MODULE__{action: String.t(), hidden: boolean()}
  end
end
