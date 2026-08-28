defmodule CorexAdmin.Action.Export do
  @moduledoc """
  Marks a resource as exportable.

  Export is the one action that cannot run as a LiveView event: the response is
  a file, and a websocket cannot deliver one. Registering this action turns on
  the export dialog, which posts to `CorexAdmin.ExportController` with a signed
  token. `handle/3` therefore never runs, and says so rather than failing
  vaguely.
  """

  @behaviour CorexAdmin.Action

  alias CorexAdmin.Gettext
  alias CorexAdmin.Resource.Spec

  @impl true
  def name, do: :export

  @impl true
  def label(%Spec{}), do: Gettext.t("Export")

  @impl true
  def kind, do: :collection

  @impl true
  def policy_action, do: :export

  @impl true
  def icon, do: "hero-arrow-down-tray"

  @impl true
  def chrome, do: :dedicated

  @impl true
  def handle(_spec, _scope, _payload) do
    {:error,
     Gettext.t("Export runs through the export controller, not as a LiveView action.")}
  end
end
