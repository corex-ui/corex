defmodule Corex.Flash do
  @moduledoc false

  defmodule Info do
    @moduledoc false
    defstruct [:title, :type, :duration]

    @type t :: %__MODULE__{
            title: String.t(),
            type: :info | :success | :error,
            duration: integer() | :infinity
          }
  end

  defmodule Error do
    @moduledoc false
    defstruct [:title, :type, :duration]

    @type t :: %__MODULE__{
            title: String.t(),
            type: :info | :success | :error,
            duration: integer() | :infinity
          }
  end
end
