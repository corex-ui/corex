defmodule CorexAdmin.Test.Policy do
  @moduledoc false
  @behaviour CorexAdmin.Policy

  @impl true
  def authorize(%{role: :admin}, _action, _resource, _record), do: :ok
  def authorize(_actor, _action, _resource, _record), do: {:error, :unauthorized}
end

defmodule CorexAdmin.Test.DenyPolicy do
  @moduledoc false
  @behaviour CorexAdmin.Policy

  @impl true
  def authorize(_actor, _action, _resource, _record), do: {:error, :unauthorized}
end
