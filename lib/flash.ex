defmodule Corex.Flash do
  @moduledoc false

  defmodule Info do
    @moduledoc """
    This struct is used to configure the info flash message toast notifications in `Corex.Toast.toast_group/1`
    """
    defstruct [:title, :type, :duration]

    @type t :: %__MODULE__{
            title: String.t(),
            type: :info | :success | :error,
            duration: integer() | :infinity
          }
  end

  defmodule Error do
    @moduledoc """
    This struct is used to configure the error flash message toast notifications in `Corex.Toast.toast_group/1`
    """
    defstruct [:title, :type, :duration]

    @type t :: %__MODULE__{
            title: String.t(),
            type: :info | :success | :error,
            duration: integer() | :infinity
          }
  end
end
