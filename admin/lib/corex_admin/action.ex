defmodule CorexAdmin.Action do
  @moduledoc """
  Behaviour for collection, bulk, and record actions.

  Built-ins (`CorexAdmin.Action.Delete`, `CorexAdmin.Action.BulkDelete`,
  `CorexAdmin.Action.Export`) render Corex `menu` / `dialog` chrome. Host modules
  must do the same — never a second UI kit. `handle/3` should call a **context**
  function; Corex Admin never calls Repo.
  """

  alias CorexAdmin.Resource.Spec

  @type payload :: map()

  @callback name() :: atom()
  @callback label(Spec.t()) :: String.t()
  @callback kind() :: :collection | :bulk | :record
  @callback policy_action() :: atom()
  @callback handle(Spec.t(), term(), payload()) :: {:ok, String.t()} | {:error, term()}

  @doc "Looks up an action module by `name/0` in a list."
  @spec fetch([module()], atom()) :: {:ok, module()} | :error
  def fetch(modules, name) when is_list(modules) and is_atom(name) do
    case Enum.find(modules, &(&1.name() == name)) do
      nil -> :error
      mod -> {:ok, mod}
    end
  end

  @doc "Whether `mod` is registered on `spec` for `kind`."
  @spec registered?(Spec.t(), atom(), module()) :: boolean()
  def registered?(%Spec{} = spec, kind, mod) when kind in [:collection, :bulk, :record] do
    mod in Map.get(spec, action_key(kind), [])
  end

  defp action_key(:collection), do: :collection_actions
  defp action_key(:bulk), do: :bulk_actions
  defp action_key(:record), do: :record_actions
end
