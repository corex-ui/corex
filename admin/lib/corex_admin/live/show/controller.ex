defmodule CorexAdmin.Live.Show.Controller do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [put_flash: 3, push_navigate: 2]

  alias CorexAdmin.Action
  alias CorexAdmin.Context
  alias CorexAdmin.History
  alias CorexAdmin.Live.Helpers

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    slug = Helpers.resource_slug(socket, params)
    id = params["id"]

    with {:ok, resource_mod} <- Helpers.fetch_resource(socket, slug),
         :ok <- Helpers.authorize(socket, :show, resource_mod, nil) do
      spec = Helpers.spec(resource_mod)
      scope = Helpers.actor(socket)

      case Context.fetch(spec, scope, id) do
        {:ok, record} ->
          case Helpers.authorize(socket, :show, resource_mod, record) do
            :ok ->
              history? =
                spec.history != nil and
                  Helpers.authorize(socket, :history, resource_mod, record) == :ok

              versions =
                if history? do
                  redact_history(
                    History.fetch(spec, Helpers.record_id(spec, record), actor: scope),
                    spec
                  )
                else
                  []
                end

              {:noreply,
               socket
               |> assign(:page_title, Helpers.record_title(spec, record))
               |> assign(:resource_mod, resource_mod)
               |> assign(:spec, spec)
               |> assign(:record, record)
               |> assign(:show_fields, Helpers.show_fields(spec, socket, record))
               |> assign(:show_sections, Helpers.section_fields(spec, :show, socket, record))
               |> assign(:history_enabled, history?)
               |> assign(:history_versions, versions)
               |> assign(:can_delete, Action.registered?(spec, :record, CorexAdmin.Action.Delete))}

            {:error, _} ->
              {:noreply, Helpers.unauthorized(socket)}
          end

        {:error, :not_found} ->
          {:noreply, Helpers.not_found(socket)}
      end
    else
      {:error, :not_found} -> {:noreply, Helpers.unauthorized(socket, :not_found)}
      {:error, _} -> {:noreply, Helpers.unauthorized(socket)}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    spec = socket.assigns.spec
    resource_mod = socket.assigns.resource_mod
    scope = Helpers.actor(socket)

    with {:ok, mod} <- Action.fetch(spec.record_actions, :delete),
         {:ok, record} <- Context.fetch(spec, scope, id),
         :ok <- Helpers.authorize(socket, :delete, resource_mod, record),
         {:ok, message} <- mod.handle(spec, scope, %{"id" => id}) do
      {:noreply,
       socket
       |> put_flash(:info, message)
       |> push_navigate(to: Helpers.resource_path(socket, spec))}
    else
      {:error, :not_found} -> {:noreply, Helpers.not_found(socket)}
      {:error, _} -> {:noreply, Helpers.unauthorized(socket)}
    end
  end

  defp redact_history(versions, spec) do
    redacted =
      spec.fields
      |> Enum.filter(& &1.redact)
      |> Enum.map(&Atom.to_string(&1.name))
      |> MapSet.new()

    Enum.map(versions, fn version ->
      changes =
        Enum.map(List.wrap(version.changes), fn change ->
          change = stringify_change(change)
          field = change["field"]

          if field in redacted do
            %{field: field, from: "••••", to: "••••"}
          else
            %{field: field, from: change["from"], to: change["to"]}
          end
        end)

      %{version | changes: changes}
    end)
  end

  defp stringify_change(change) when is_map(change) do
    Map.new(change, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} -> {to_string(key), value}
    end)
  end

  defp stringify_change(_), do: %{"field" => nil, "from" => nil, "to" => nil}
end
