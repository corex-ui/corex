defmodule CorexAdmin.Action.Export do
  @moduledoc false

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
  def handle(_spec, _scope, _payload) do
    {:error, :use_export_controller}
  end
end
