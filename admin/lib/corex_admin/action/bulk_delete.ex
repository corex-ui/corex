defmodule CorexAdmin.Action.BulkDelete do
  @moduledoc false

  @behaviour CorexAdmin.Action

  alias CorexAdmin.Context
  alias CorexAdmin.Gettext
  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Resource.Spec

  @impl true
  def name, do: :bulk_delete

  @impl true
  def label(%Spec{} = spec), do: Gettext.t("Delete selected %{name}", name: spec.label)

  @impl true
  def kind, do: :bulk

  @impl true
  def policy_action, do: :delete

  @impl true
  def handle(%Spec{} = spec, scope, payload) do
    ids = List.wrap(payload["ids"])
    resource_mod = spec.module
    socket_or_assigns = payload[:assigns]

    {deleted, denied} =
      Enum.reduce(ids, {0, 0}, fn id, {ok, no} ->
        case Context.fetch(spec, scope, id) do
          {:ok, record} ->
            allowed? =
              if socket_or_assigns do
                Helpers.authorize(socket_or_assigns, :delete, resource_mod, record) == :ok
              else
                true
              end

            if allowed? do
              case Context.delete(spec, scope, record) do
                {:ok, _} -> {ok + 1, no}
                _ -> {ok, no + 1}
              end
            else
              {ok, no + 1}
            end

          {:error, _} ->
            {ok, no + 1}
        end
      end)

    cond do
      deleted > 0 and denied == 0 ->
        {:ok, Gettext.t("Deleted %{count}.", count: deleted)}

      deleted > 0 ->
        {:ok,
         Gettext.t("Deleted %{count}. %{denied} could not be deleted.",
           count: deleted,
           denied: denied
         )}

      true ->
        {:error, :could_not_delete}
    end
  end
end
