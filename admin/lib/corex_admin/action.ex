defmodule CorexAdmin.Action do
  @moduledoc """
  Behaviour for collection, bulk, and record actions.

  An action is a module the resource registers. `handle/3` calls a **host context
  function** — Corex Admin never calls Repo — and the optional callbacks below
  describe how the action presents itself, so the index chrome can render it
  without knowing what it does.

      defmodule MyApp.Admin.Actions.Assign do
        @behaviour CorexAdmin.Action

        def name, do: :assign
        def kind, do: :bulk
        def label(_spec), do: "Assign owner"
        def policy_action, do: :update
        def icon, do: "hero-user-plus"

        def form_fields(_spec) do
          [%{name: :owner_id, type: :select, label: "Owner", options: [{"Ada", "1"}]}]
        end

        def handle(_spec, scope, %{"ids" => ids, "payload" => %{"owner_id" => owner}}) do
          case MyApp.Support.assign_tickets(scope, ids, owner) do
            {:ok, n} -> {:ok, "Assigned \#{n} tickets."}
            {:error, _} = error -> error
          end
        end
      end

  ## Payload

  `handle/3` receives string-keyed params:

    * `"id"` — record actions, plus `:record` with the fetched record
    * `"ids"` — bulk actions, the current selection
    * `"payload"` — values from `form_fields/1`, when declared

  ## Presentation callbacks

  | Callback | Default | Effect |
  | -------- | ------- | ------ |
  | `icon/0` | `hero-bolt` | Trigger icon |
  | `form_fields/1` | `[]` | Inputs in the action dialog |
  | `confirm/1` | `nil` | Dialog description; presence implies confirmation |
  | `destructive?/0` | `false` | Alert styling and `alertdialog` role |

  Built-ins (`Delete`, `BulkDelete`, `Export`) implement the same behaviour and
  are registered like any other action.
  """

  alias CorexAdmin.Resource.Spec

  @type payload :: map()

  @type form_field :: %{
          required(:name) => atom(),
          optional(:type) => :text | :number | :select | :boolean | :date | :email,
          optional(:label) => String.t(),
          optional(:options) => [term()],
          optional(:required) => boolean()
        }

  @doc "Stable identifier, used in events and dialog ids."
  @callback name() :: atom()

  @doc "Button label."
  @callback label(Spec.t()) :: String.t()

  @doc "Where the action appears."
  @callback kind() :: :collection | :bulk | :record

  @doc "Policy action checked before `handle/3`."
  @callback policy_action() :: atom()

  @doc "Runs the action against a host context."
  @callback handle(Spec.t(), term(), payload()) :: {:ok, String.t()} | {:error, term()}

  @doc "Heroicon name for the trigger."
  @callback icon() :: String.t()

  @doc "Inputs to collect before running."
  @callback form_fields(Spec.t()) :: [form_field()]

  @doc "Confirmation copy. Returning a string makes the dialog a confirmation."
  @callback confirm(Spec.t()) :: String.t() | nil

  @doc "Whether the action destroys data."
  @callback destructive?() :: boolean()

  @optional_callbacks icon: 0, form_fields: 1, confirm: 1, destructive?: 0

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

  @doc "Actions of `kind` registered on `spec`, excluding ones with dedicated chrome."
  @spec custom(Spec.t(), atom()) :: [module()]
  def custom(%Spec{} = spec, kind) do
    spec
    |> Map.get(action_key(kind), [])
    |> Enum.reject(&(&1 in [CorexAdmin.Action.Delete, CorexAdmin.Action.BulkDelete]))
    |> Enum.reject(&(&1 == CorexAdmin.Action.Export))
  end

  @doc "Trigger icon for `mod`."
  @spec icon(module()) :: String.t()
  def icon(mod) do
    if function_exported?(mod, :icon, 0), do: mod.icon(), else: "hero-bolt"
  end

  @doc "Form fields declared by `mod`."
  @spec form_fields(module(), Spec.t()) :: [form_field()]
  def form_fields(mod, %Spec{} = spec) do
    if function_exported?(mod, :form_fields, 1) do
      mod.form_fields(spec) |> List.wrap() |> Enum.filter(&is_map/1)
    else
      []
    end
  end

  @doc "Confirmation copy declared by `mod`."
  @spec confirm(module(), Spec.t()) :: String.t() | nil
  def confirm(mod, %Spec{} = spec) do
    if function_exported?(mod, :confirm, 1), do: mod.confirm(spec)
  end

  @doc "Whether `mod` destroys data."
  @spec destructive?(module()) :: boolean()
  def destructive?(mod) do
    function_exported?(mod, :destructive?, 0) and mod.destructive?()
  end

  defp action_key(:collection), do: :collection_actions
  defp action_key(:bulk), do: :bulk_actions
  defp action_key(:record), do: :record_actions
end
