defmodule CorexAdmin.Live.Form.Controller do
  @moduledoc """
  Behaviour behind `use CorexAdmin.Live, :form`.
  """

  import Phoenix.Component, only: [assign: 3, to_form: 2]
  import Phoenix.LiveView, only: [put_flash: 3, push_navigate: 2]

  alias CorexAdmin.Action
  alias CorexAdmin.Attrs
  alias CorexAdmin.Context
  alias CorexAdmin.Gettext
  alias CorexAdmin.Live.Helpers
  alias CorexAdmin.Params
  alias CorexAdmin.Resource.Field

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    slug = Helpers.resource_slug(socket, params)
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

  # A searchable relation picker asks for options as the user types, so large
  # tables never ship every row to the client.
  def handle_event("relation_search", params, socket) do
    query = Params.event_value(params) || ""
    id = to_string(Map.get(params, "id") || "")

    case relation_field_for_control(socket.assigns.spec, id) do
      nil ->
        {:noreply, socket}

      field ->
        options =
          Helpers.relation_options(field, Helpers.actor(socket),
            query: query,
            limit: field.relation.limit
          )

        current = socket.assigns[:relation_options] || %{}
        {:noreply, assign(socket, :relation_options, Map.put(current, field.name, options))}
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

  defp load_form(socket, spec, resource_mod, scope, :new, _params) do
    changeset = Context.change_create(spec, scope, %{})
    fields = Helpers.form_fields(spec, socket, nil)

    {:ok,
     socket
     |> assign(:page_title, Gettext.t("New %{name}", name: spec.singular))
     |> assign(:resource_mod, resource_mod)
     |> assign(:spec, spec)
     |> assign(:record, nil)
     |> assign(:form_fields, fields)
     |> assign(:form_sections, Helpers.section_fields(spec, :form, socket, nil))
     |> assign(:relation_options, load_relation_options(fields, scope))
     |> assign_form(changeset)}
  end

  defp load_form(socket, spec, resource_mod, scope, :edit, params) do
    case Context.fetch(spec, scope, params["id"]) do
      {:ok, record} ->
        case Helpers.authorize(socket, :edit, resource_mod, record) do
          :ok ->
            changeset = Context.change_update(spec, scope, record, %{})
            fields = Helpers.form_fields(spec, socket, record)

            {:ok,
             socket
             |> assign(
               :page_title,
               Gettext.t("Edit %{title}", title: Helpers.record_title(spec, record))
             )
             |> assign(:resource_mod, resource_mod)
             |> assign(:spec, spec)
             |> assign(:record, record)
             |> assign(:form_fields, fields)
             |> assign(:form_sections, Helpers.section_fields(spec, :form, socket, record))
             |> assign(:relation_options, load_relation_options(fields, scope))
             |> assign_form(changeset)}

          {:error, _} ->
            {:error, Helpers.unauthorized(socket)}
        end

      {:error, :not_found} ->
        {:error, Helpers.not_found(socket)}
    end
  end

  # "Create and add another" returns to a blank form; plain "Create" goes to the
  # record that was just made.
  defp save_new(socket, spec, resource_mod, scope, attrs, continue?) do
    with :ok <- Helpers.authorize(socket, :create, resource_mod, nil),
         {:ok, record} <- Context.create(spec, scope, attrs) do
      dest =
        if continue?,
          do: Helpers.new_path(socket, spec),
          else: Helpers.record_path(socket, spec, record)

      {:noreply,
       socket
       |> put_flash(:info, Gettext.t("Created."))
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
         |> assign(
           :page_title,
           Gettext.t("Edit %{title}", title: Helpers.record_title(spec, record))
         )
         |> assign_form(changeset)
         |> put_flash(:info, Gettext.t("Updated."))}
      else
        {:noreply,
         socket
         |> put_flash(:info, Gettext.t("Updated."))
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

  defp load_relation_options(fields, scope) do
    fields
    |> Enum.filter(&Field.relation?/1)
    |> Map.new(fn field ->
      {field.name, Helpers.relation_options(field, scope, limit: field.relation.limit)}
    end)
  end

  defp relation_field_for_control(spec, control_id) do
    Enum.find(spec.fields, fn field ->
      Field.relation?(field) and control_id != "" and
        String.contains?(control_id, relation_control_key(field))
    end)
  end

  defp relation_control_key(field) do
    field |> CorexAdmin.UI.Fields.relation_key() |> Atom.to_string()
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
