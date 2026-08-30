defmodule E2eWeb.AdminPolicy do
  @moduledoc false
  @behaviour CorexAdmin.Policy

  @impl true
  def authorize(%E2e.AdminDemo.Scope{role: :admin}, _action, _resource, _record), do: :ok
  def authorize(_actor, _action, _resource, _record), do: {:error, :unauthorized}
end
