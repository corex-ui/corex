defmodule Corex.Json do
  @moduledoc false

  @default Jason

  def encoder do
    Application.get_env(:corex, :json_library, @default)
  end

  def encode!(term) do
    encoder().encode!(term)
  end
end
