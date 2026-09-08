defmodule CorexAdmin.Test.Actions.Assign do
  @moduledoc false
  @behaviour CorexAdmin.Action

  alias CorexAdmin.Context
  alias CorexAdmin.Resource.Spec

  @impl true
  def name, do: :assign

  @impl true
  def label(%Spec{}), do: "Assign status"

  @impl true
  def kind, do: :bulk

  @impl true
  def policy_action, do: :update

  @impl true
  def icon, do: "hero-user-plus"

  @impl true
  def form_fields(%Spec{}) do
    [
      %{
        name: :status,
        type: :select,
        label: "Status",
        options: [{"Open", "open"}, {"Done", "done"}],
        required: true
      }
    ]
  end

  @impl true
  def handle(%Spec{} = spec, scope, payload) do
    status = get_in(payload, ["payload", "status"]) || "done"
    ids = List.wrap(payload["ids"])

    count =
      Enum.count(ids, fn id ->
        case Context.fetch(spec, scope, id) do
          {:ok, record} ->
            match?({:ok, _}, Context.update(spec, scope, record, %{"status" => status}))

          _ ->
            false
        end
      end)

    {:ok, "Assigned #{count}."}
  end
end
