defmodule CorexAdmin.Live.Show do
  @moduledoc false

  use Phoenix.LiveView
  use Corex

  alias CorexAdmin.Context
  alias CorexAdmin.Live.Components
  alias CorexAdmin.Live.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    slug = params["resource"]
    id = params["id"]

    with {:ok, resource_mod} <- Helpers.fetch_resource(socket, slug),
         :ok <- Helpers.authorize(socket, :show, resource_mod, nil) do
      spec = Helpers.spec(resource_mod)
      scope = Helpers.actor(socket)

      case Context.fetch(spec, scope, id) do
        {:ok, record} ->
          case Helpers.authorize(socket, :show, resource_mod, record) do
            :ok ->
              {:noreply,
               socket
               |> assign(:page_title, Helpers.record_title(spec, record))
               |> assign(:resource_mod, resource_mod)
               |> assign(:spec, spec)
               |> assign(:record, record)
               |> assign(:show_fields, Helpers.show_fields(spec))}

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

  @impl true
  def render(assigns) do
    ~H"""
    <Components.shell :if={assigns[:record]} socket={assigns} current={@spec}>
      <div class="flex w-full flex-col gap-space-lg">
        <Components.breadcrumbs
          prefix={@corex_admin_prefix}
          spec={@spec}
          live_action={:show}
          record={@record}
        />
        <.layout_heading class="layout-heading">
          <:title>{Helpers.record_title(@spec, @record)}</:title>
          <:actions>
            <.navigate
              to={Helpers.resource_path(assigns, @spec)}
              type="navigate"
              class="button"
              aria_label="Back"
            >
              <.heroicon name="hero-arrow-left" />
            </.navigate>
            <.navigate
              :if={Helpers.authorize(assigns, :edit, @resource_mod, @record) == :ok}
              to={Helpers.edit_path(assigns, @spec, @record)}
              type="navigate"
              class="button ui-accent"
              aria_label="Edit"
            >
              <.heroicon name="hero-pencil-square" /> Edit
            </.navigate>
            <Components.delete_dialog
              :if={Helpers.authorize(assigns, :delete, @resource_mod, @record) == :ok}
              id={"delete-#{Helpers.record_id(@spec, @record)}"}
              spec={@spec}
              record={@record}
              trigger={:labeled}
            />
          </:actions>
        </.layout_heading>

        <.data_list
          class="data-list w-full"
          items={
            Corex.Content.new(
              for field <- @show_fields, field.type != :embeds_many do
                %{
                  value: Atom.to_string(field.name),
                  label: field.label,
                  content: Components.format_value(field, @record)
                }
              end
            )
          }
        />
        <Components.embed_show
          :for={field <- Enum.filter(@show_fields, &(&1.type == :embeds_many))}
          field={field}
          record={@record}
        />
      </div>
    </Components.shell>
    """
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    spec = socket.assigns.spec
    resource_mod = socket.assigns.resource_mod
    scope = Helpers.actor(socket)

    case Context.fetch(spec, scope, id) do
      {:ok, record} ->
        with :ok <- Helpers.authorize(socket, :delete, resource_mod, record),
             {:ok, _} <- Context.delete(spec, scope, record) do
          {:noreply,
           socket
           |> put_flash(:info, "Deleted.")
           |> push_navigate(to: Helpers.resource_path(socket, spec))}
        else
          {:error, _} -> {:noreply, Helpers.unauthorized(socket)}
        end

      {:error, :not_found} ->
        {:noreply, Helpers.not_found(socket)}
    end
  end
end
