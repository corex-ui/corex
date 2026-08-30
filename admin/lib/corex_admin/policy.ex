defmodule CorexAdmin.Policy do
  @moduledoc """
  Deny-by-default authorization contract.

  Implement `authorize/4` on a module and pass it as `policy:` to `use CorexAdmin`.
  Every LiveView mount, `handle_params`, and mutating event must go through this
  callback. Hiding a button in HEEx is not authorization.

  Return `:ok` to allow or `{:error, reason}` to deny. The installer generates a
  policy that **always denies** — you must allow explicitly.

  The actor is `socket.assigns[actor_assign]` (typically a Phoenix scope).

  Optional `authorize_field/5` can hide or lock individual fields. When omitted,
  field `readable` / `writable` / `redact` flags on the resource are the only gate.

  This behaviour is intentionally close to Bodyguard (`authorize/3`) so you can
  wrap an existing policy without taking Bodyguard or Permit as a dependency.
  """

  @type actor :: term()
  @type action :: atom()
  @type resource :: module()
  @type record :: term() | nil
  @type field :: atom()

  @callback authorize(actor(), action(), resource(), record()) ::
              :ok | {:error, term()}

  @callback authorize_field(actor(), action(), resource(), record(), field()) ::
              :ok | {:error, term()}

  @optional_callbacks authorize_field: 5

  @doc "Calls `authorize/4`. Missing implementation is a compile error on the policy module."
  @spec authorize(module(), actor(), action(), resource(), record()) :: :ok | {:error, term()}
  def authorize(policy, actor, action, resource, record) do
    policy.authorize(actor, action, resource, record)
  end

  @doc "Calls optional `authorize_field/5`, otherwise `:ok` (field flags still apply)."
  @spec authorize_field(module(), actor(), action(), resource(), record(), field()) ::
          :ok | {:error, term()}
  def authorize_field(policy, actor, action, resource, record, field) do
    if function_exported?(policy, :authorize_field, 5) do
      policy.authorize_field(actor, action, resource, record, field)
    else
      :ok
    end
  end
end
