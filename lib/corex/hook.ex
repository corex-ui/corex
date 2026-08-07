defmodule Corex.Hook do
  @moduledoc """
  Attributes shared by every component root that mounts a JavaScript hook.

  A hook root carries `data-loading` so CSS can style the pre-hydration frame,
  plus a `phx-mounted` that tells LiveView to stop patching that attribute once
  the hook removes it. The two must always agree on the attribute name, so they
  are emitted together rather than repeated per component.
  """

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
