defmodule Corex.Translation do
  @moduledoc false

  def take(nil, default), do: default
  def take("", default), do: default
  def take(value, _default), do: value
end
