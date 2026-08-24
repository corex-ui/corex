defmodule <%= inspect web_module %>.AdminPolicy do
  @moduledoc """
  Deny-by-default Corex Admin policy.

  Authentication is handled by your `on_mount` hooks. Allow actions explicitly
  here — never return `:ok` for every clause.
  """

  @behaviour CorexAdmin.Policy

  @impl true
  def authorize(_actor, _action, _resource, _record), do: {:error, :unauthorized}
end
