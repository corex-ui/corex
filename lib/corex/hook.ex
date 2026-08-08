defmodule Corex.Hook do
  @moduledoc false

  alias Phoenix.LiveView.JS

  @loading_attr "data-loading"

  @doc """
  Marks a hook root as loading until its hook clears the attribute.

      <div id={@id} phx-hook="Select" {Corex.Hook.loading()} {@rest}>
  """
  @spec loading() :: map()
  def loading do
    %{@loading_attr => true, "phx-mounted" => JS.ignore_attributes([@loading_attr])}
  end
end
