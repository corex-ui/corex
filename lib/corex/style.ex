defmodule Corex.Style do
  @moduledoc false

  @doc false
  def merge_class(classes) do
    classes
    |> List.wrap()
    |> Enum.reject(&(&1 in [nil, ""]))
    |> Enum.join(" ")
  end
end
