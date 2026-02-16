defmodule Corex.Avatar.Anatomy do
  @moduledoc false

  defmodule Props do
    @moduledoc false
    @enforce_keys [:id]

    defstruct [
      :id,
      on_status_change: nil,
      on_status_change_client: nil
    ]

    @type t :: %__MODULE__{
            id: String.t(),
            on_status_change: String.t() | nil,
            on_status_change_client: String.t() | nil
          }
  end

  defmodule Root do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Image do
    @moduledoc false
    defstruct [:id, :src]

    @type t :: %__MODULE__{id: String.t(), src: String.t() | nil}
  end

  defmodule Fallback do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end

  defmodule Skeleton do
    @moduledoc false
    defstruct [:id]

    @type t :: %__MODULE__{id: String.t()}
  end
end
