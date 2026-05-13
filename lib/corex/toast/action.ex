defmodule Corex.Toast.Action do
  @moduledoc false

  @enforce_keys [:label, :js]
  defstruct [:label, :js, :class]
end
