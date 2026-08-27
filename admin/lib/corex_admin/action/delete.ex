defmodule CorexAdmin.Action.Delete do
  @moduledoc false

  @behaviour CorexAdmin.Action

  alias CorexAdmin.Context
  alias CorexAdmin.Gettext
  alias CorexAdmin.Resource.Spec

  @impl true
  def name, do: :delete

  @impl true
  def label(%Spec{} = spec), do: Gettext.t("Delete %{name}", name: spec.singular)

  @impl true
  def kind, do: :record

  @impl true
  def policy_action, do: :delete

  @impl true
  def handle(%Spec{} = spec, scope, payload) do
    id = payload["id"]

    case Context.fetch(spec, scope, id) do
      {:ok, record} ->
        case Context.delete(spec, scope, record) do
          {:ok, _} -> {:ok, Gettext.t("Deleted.")}
          {:error, reason} -> {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
