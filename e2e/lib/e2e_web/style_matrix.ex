defmodule E2eWeb.StyleMatrix do
  @moduledoc false

  def visible?, do: Mix.env() in [:dev, :test]
end
