defmodule Corex.Offset do
  @moduledoc "Main-axis and cross-axis offset pair for layout."

  defstruct main_axis: nil, cross_axis: nil

  @type t :: %__MODULE__{main_axis: number() | nil, cross_axis: number() | nil}
end
