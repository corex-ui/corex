defmodule E2eWeb.Admin.Actions.SetTicketStatus do
  @moduledoc """
  Bulk action with a form: move the selected tickets to one status.

  This is the shape a real staff tool needs and that a confirm-only action
  cannot express — the operator has to say *which* status before anything runs.
  """

  @behaviour CorexAdmin.Action

  alias CorexAdmin.Resource.Spec

  @impl true
  def name, do: :set_status

  @impl true
  def label(%Spec{}), do: "Set status"

  @impl true
  def kind, do: :bulk

  @impl true
  def policy_action, do: :update

  @impl true
  def icon, do: "hero-arrow-path"

  @impl true
  def form_fields(%Spec{}) do
    [
      %{
        name: :status,
        type: :select,
        label: "New status",
        options: [{"Open", "open"}, {"Pending", "pending"}, {"Done", "done"}],
        required: true
      }
    ]
  end

  @impl true
  def handle(%Spec{}, scope, payload) do
    status = get_in(payload, ["payload", "status"])
    ids = List.wrap(payload["ids"])

    cond do
      ids == [] ->
        {:error, "Select at least one ticket first."}

      status not in E2e.AdminDemo.Ticket.statuses() ->
        {:error, "Pick a status."}

      true ->
        case E2e.AdminDemo.set_ticket_status(scope, ids, status) do
          {:ok, count} -> {:ok, "Moved #{count} ticket(s) to #{status}."}
          {:error, _} = error -> error
        end
    end
  end
end
