defmodule CorexAdmin.Action.Delete do
  @moduledoc """
  Deletes one record through the resource's `delete` context function.

  Registered by default. Its confirmation dialog is part of the index and show
  chrome, so it declares `chrome/0` as `:dedicated`.
  """

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
  def icon, do: "hero-trash"

  @impl true
  def destructive?, do: true

  @impl true
  def chrome, do: :dedicated

  @impl true
  def confirm(%Spec{}), do: Gettext.t("This action cannot be undone.")

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
