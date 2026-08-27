defmodule CorexAdmin.Live.Form do
  @moduledoc false

  use Phoenix.LiveView
  use Corex

  alias CorexAdmin.Attrs
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
    action = socket.assigns.live_action
    policy_action = if action == :new, do: :new, else: :edit

    with {:ok, resource_mod} <- Helpers.fetch_resource(socket, slug),
         :ok <- Helpers.authorize(socket, policy_action, resource_mod, nil) do
      spec = Helpers.spec(resource_mod)
      scope = Helpers.actor(socket)

      case load_form(socket, spec, resource_mod, scope, action, params) do
        {:ok, socket} -> {:noreply, socket}
        {:error, socket} -> {:noreply, socket}
      end
    else
      {:error, :not_found} -> {:noreply, Helpers.unauthorized(socket, :not_found)}
      {:error, _} -> {:noreply, Helpers.unauthorized(socket)}
    end
  end

  defp load_form(socket, spec, resource_mod, scope, :new, _params) do
    changeset = Context.change_create(spec, scope, %{})

    {:ok,
     socket
     |> assign(:page_title, "New #{spec.label}")
     |> assign(:resource_mod, resource_mod)
     |> assign(:spec, spec)
     |> assign(:record, nil)
     |> assign(:form_fields, Helpers.form_fields(spec))
     |> assign_form(changeset)}
  end

  defp load_form(socket, spec, resource_mod, scope, :edit, params) do
    case Context.fetch(spec, scope, params["id"]) do
      {:ok, record} ->
        case Helpers.authorize(socket, :edit, resource_mod, record) do
          :ok ->
            changeset = Context.change_update(spec, scope, record, %{})

            {:ok,
             socket
             |> assign(:page_title, "Edit #{Helpers.record_title(spec, record)}")
             |> assign(:resource_mod, resource_mod)
             |> assign(:spec, spec)
             |> assign(:record, record)
             |> assign(:form_fields, Helpers.form_fields(spec))
             |> assign_form(changeset)}

          {:error, _} ->
            {:error, Helpers.unauthorized(socket)}
        end

      {:error, :not_found} ->
        {:error, Helpers.not_found(socket)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Components.shell
      :if={assigns[:form]}
      socket={assigns}
      current={@spec}
      live_action={@live_action}
      record={@record}
    >
      <div class="admin-stack admin-stack--lg">
        <Components.breadcrumbs
          prefix={@corex_admin_prefix}
          spec={@spec}
          live_action={@live_action}
          record={@record}
        />
        <.layout_heading class="layout-heading">
          <:title>{@page_title}</:title>
          <:actions>
            <.navigate
              to={Helpers.resource_path(assigns, @spec)}
              type="navigate"
              class="button ui-trigger--square"
              aria_label="Cancel"
              title="Cancel"
            >
              <.heroicon name="hero-arrow-left" />
              <span class="sr-only">Back to {@spec.label}</span>
            </.navigate>
          </:actions>
        </.layout_heading>

        <.form
          for={@form}
          id={@form.id}
          phx-change="validate"
          phx-submit="save"
          class="admin-form"
        >
          <div class="admin-form-grid">
            <div
              :for={field <- @form_fields}
              class={if field.type in [:textarea, :embeds_many], do: "admin-form-span"}
            >
              <Components.field_input field={field} form={@form} />
            </div>
          </div>
          <div class="admin-actions">
            <.action type="submit" class="button ui-solid ui-brand">Save</.action>
            <.action type="submit" name="continue" value="true" class="button">
              Save and continue
            </.action>
          </div>
        </.form>
      </div>
    </Components.shell>
    """
  end

  @impl true
  def handle_event("validate", params, socket) do
    spec = socket.assigns.spec
    scope = Helpers.actor(socket)
    attrs = Attrs.take_writable(spec, form_params(params, spec))

    changeset =
      case socket.assigns.live_action do
        :new ->
          spec
          |> Context.change_create(scope, attrs)
          |> Map.put(:action, :validate)

        :edit ->
          spec
          |> Context.change_update(scope, socket.assigns.record, attrs)
          |> Map.put(:action, :validate)
      end

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", params, socket) do
    spec = socket.assigns.spec
    resource_mod = socket.assigns.resource_mod
    scope = Helpers.actor(socket)
    attrs = Attrs.take_writable(spec, form_params(params, spec))
    continue? = continue?(params)

    case socket.assigns.live_action do
      :new -> save_new(socket, spec, resource_mod, scope, attrs, continue?)
      :edit -> save_edit(socket, spec, resource_mod, scope, attrs, continue?)
    end
  end

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

  defp save_new(socket, spec, resource_mod, scope, attrs, continue?) do
    with :ok <- Helpers.authorize(socket, :create, resource_mod, nil),
         {:ok, record} <- Context.create(spec, scope, attrs) do
      dest =
        if continue?,
          do: Helpers.edit_path(socket, spec, record),
          else: Helpers.record_path(socket, spec, record)

      {:noreply,
       socket
       |> put_flash(:info, "Created.")
       |> push_navigate(to: dest)}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}

      {:error, _} ->
        {:noreply, Helpers.unauthorized(socket)}
    end
  end

  defp save_edit(socket, spec, resource_mod, scope, attrs, continue?) do
    record = socket.assigns.record

    with :ok <- Helpers.authorize(socket, :update, resource_mod, record),
         {:ok, record} <- Context.update(spec, scope, record, attrs) do
      if continue? do
        changeset = Context.change_update(spec, scope, record, %{})

        {:noreply,
         socket
         |> assign(:record, record)
         |> assign(:page_title, "Edit #{Helpers.record_title(spec, record)}")
         |> assign_form(changeset)
         |> put_flash(:info, "Updated.")}
      else
        {:noreply,
         socket
         |> put_flash(:info, "Updated.")
         |> push_navigate(to: Helpers.record_path(socket, spec, record))}
      end
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :update))}

      {:error, _} ->
        {:noreply, Helpers.unauthorized(socket)}
    end
  end

  defp continue?(params) do
    params["continue"] in ["true", "continue", true]
  end

  defp form_params(params, spec) do
    as = form_as(spec)
    Map.get(params, as) || Map.get(params, spec.slug) || %{}
  end

  defp assign_form(socket, changeset) do
    spec = socket.assigns.spec
    as = form_as(spec)
    assign(socket, :form, to_form(changeset, as: as, id: "#{spec.slug}-form"))
  end

  defp form_as(spec) do
    spec.schema
    |> Module.split()
    |> List.last()
    |> Macro.underscore()
  end
end
