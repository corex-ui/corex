defmodule CorexAdmin.Live.Helpers do
  @moduledoc false

  import Phoenix.LiveView, only: [put_flash: 3, push_navigate: 2]

  require Logger

  alias CorexAdmin.Gettext
  alias CorexAdmin.ListOpts
  alias CorexAdmin.Policy
  alias CorexAdmin.Resource.Field
  alias CorexAdmin.Resource.Spec

  def spec(resource_mod), do: resource_mod.__corex_admin_resource__()

  def config(socket_or_assigns), do: view_assigns(socket_or_assigns).corex_admin.__corex_admin__()

  def actor(socket_or_assigns) do
    assigns = view_assigns(socket_or_assigns)
    Map.get(assigns, config(assigns).actor_assign)
  end

  def fetch_resource(socket_or_assigns, slug) when is_binary(slug) do
    case CorexAdmin.resource_for_slug(view_assigns(socket_or_assigns).corex_admin, slug) do
      {:ok, module} -> {:ok, module}
      :error -> {:error, :not_found}
    end
  end

  def fetch_resource(_socket_or_assigns, _slug), do: {:error, :not_found}

  @doc "Resource slug from params or the mounted path (explicit per-resource routes)."
  def resource_slug(socket_or_assigns, params) when is_map(params) do
    case params["resource"] do
      slug when is_binary(slug) and slug != "" ->
        slug

      _ ->
        assigns = view_assigns(socket_or_assigns)
        slug_from_path(assigns[:corex_admin_prefix], assigns[:corex_admin_path])
    end
  end

  defp slug_from_path(prefix, path) when is_binary(prefix) and is_binary(path) do
    relative =
      path
      |> String.split("?", parts: 2)
      |> hd()
      |> String.replace_prefix(prefix, "")
      |> String.trim("/")

    case String.split(relative, "/", trim: true) do
      [slug | _] -> slug
      _ -> nil
    end
  end

  defp slug_from_path(_, _), do: nil

  def unauthorized(socket, reason \\ :unauthorized) do
    message =
      case reason do
        :unauthorized -> Gettext.t("You are not authorized to perform this action.")
        :not_found -> Gettext.t("Unknown resource.")
        other when is_binary(other) -> other
        _ -> Gettext.t("You are not authorized to perform this action.")
      end

    socket
    |> put_flash(:error, message)
    |> push_navigate(to: home_path(socket))
  end

  def authorize(socket_or_assigns, action, resource_mod, record) do
    assigns = view_assigns(socket_or_assigns)
    policy = config(assigns).policy
    result = Policy.authorize(policy, actor(assigns), action, resource_mod, record)

    if CorexAdmin.debug?() do
      Logger.debug(fn ->
        "corex_admin authorize action=#{inspect(action)} resource=#{inspect(resource_mod)} result=#{inspect(result)}"
      end)
    end

    result
  end

  def authorize_field(socket_or_assigns, action, resource_mod, record, field_name) do
    assigns = view_assigns(socket_or_assigns)
    policy = config(assigns).policy
    Policy.authorize_field(policy, actor(assigns), action, resource_mod, record, field_name)
  end

  def not_found(socket) do
    socket
    |> put_flash(:error, Gettext.t("Record not found."))
    |> push_navigate(to: home_path(socket))
  end

  def home_path(socket_or_assigns), do: view_assigns(socket_or_assigns).corex_admin_prefix

  def current_path(socket_or_assigns) do
    assigns = view_assigns(socket_or_assigns)
    Map.get(assigns, :corex_admin_path) || home_path(assigns)
  end

  def hub_title(socket_or_assigns) do
    config(socket_or_assigns).title || "Admin"
  end

  def hub_description(socket_or_assigns) do
    config(socket_or_assigns).description
  end

  def resource_path(socket_or_assigns, slug) when is_binary(slug) do
    Path.join(home_path(socket_or_assigns), slug)
  end

  def resource_path(socket_or_assigns, %Spec{slug: slug}),
    do: resource_path(socket_or_assigns, slug)

  def new_path(socket_or_assigns, spec_or_slug) do
    Path.join(resource_path(socket_or_assigns, spec_or_slug), "new")
  end

  def record_path(socket_or_assigns, spec_or_slug, record) do
    Path.join(resource_path(socket_or_assigns, spec_or_slug), record_id(spec_or_slug, record))
  end

  def edit_path(socket_or_assigns, spec_or_slug, record) do
    Path.join(record_path(socket_or_assigns, spec_or_slug, record), "edit")
  end

  def export_path(socket_or_assigns, spec_or_slug) do
    Path.join(resource_path(socket_or_assigns, spec_or_slug), "export")
  end

  def index_path(socket_or_assigns, spec_or_slug, %ListOpts{} = opts) do
    path = resource_path(socket_or_assigns, spec_or_slug)
    params = ListOpts.to_params(opts)

    if params == %{} do
      path
    else
      path <> "?" <> Plug.Conn.Query.encode(params)
    end
  end

  def pagination_to(socket_or_assigns, spec_or_slug, %ListOpts{} = opts) do
    params = opts |> ListOpts.to_params() |> Map.delete("page")
    path = resource_path(socket_or_assigns, spec_or_slug)

    if params == %{} do
      path
    else
      path <> "?" <> Plug.Conn.Query.encode(params)
    end
  end

  def record_id(%Spec{primary_key: key}, record), do: record |> Map.fetch!(key) |> to_string()
  def record_id(_slug, record) when is_map(record), do: record |> Map.fetch!(:id) |> to_string()

  def record_title(%Spec{} = spec, record) do
    if function_exported?(spec.module, :title, 1) do
      case spec.module.title(record) do
        value when value in [nil, ""] -> record_id(spec, record)
        value -> to_string(value)
      end
    else
      CorexAdmin.Resource.default_title(spec, record)
    end
  end

  def index_fields(%Spec{} = spec), do: Enum.filter(spec.fields, & &1.index)

  def index_fields(%Spec{} = spec, socket_or_assigns) do
    filter_authorized_fields(index_fields(spec), socket_or_assigns, :index, spec.module, nil)
  end

  def show_fields(%Spec{} = spec), do: Enum.filter(spec.fields, & &1.show)

  def show_fields(%Spec{} = spec, socket_or_assigns, record) do
    filter_authorized_fields(show_fields(spec), socket_or_assigns, :show, spec.module, record)
  end

  def form_fields(%Spec{} = spec), do: Enum.filter(spec.fields, & &1.writable)

  def form_fields(%Spec{} = spec, socket_or_assigns, record) do
    action = if is_nil(record), do: :new, else: :edit
    filter_authorized_fields(form_fields(spec), socket_or_assigns, action, spec.module, record)
  end

  def export_fields(%Spec{} = spec, socket_or_assigns) do
    spec.fields
    |> Enum.filter(&(&1.readable and not &1.redact and &1.type != :password))
    |> filter_authorized_fields(socket_or_assigns, :export, spec.module, nil)
  end

  def section_fields(%Spec{} = spec, :form, socket_or_assigns, record) do
    resolve_sections(spec.form_sections, form_fields(spec, socket_or_assigns, record))
  end

  def section_fields(%Spec{} = spec, :show, socket_or_assigns, record) do
    resolve_sections(spec.show_sections, show_fields(spec, socket_or_assigns, record))
  end

  defp resolve_sections([], fields), do: [%{name: :default, label: nil, fields: fields}]

  defp resolve_sections(sections, fields) do
    by_name = Map.new(fields, &{&1.name, &1})

    resolved =
      Enum.map(sections, fn section ->
        %{
          name: section.name,
          label: section.label,
          fields: Enum.flat_map(section.fields, fn name -> List.wrap(Map.get(by_name, name)) end)
        }
      end)
      |> Enum.reject(&(&1.fields == []))

    if resolved == [], do: [%{name: :default, label: nil, fields: fields}], else: resolved
  end

  defp filter_authorized_fields(fields, socket_or_assigns, action, resource_mod, record) do
    Enum.filter(fields, fn %Field{name: name} ->
      authorize_field(socket_or_assigns, action, resource_mod, record, name) == :ok
    end)
  end

  def grouped_resources(socket_or_assigns) do
    assigns = view_assigns(socket_or_assigns)
    config = config(assigns)

    config.resources
    |> Enum.filter(fn resource_mod ->
      authorize(assigns, :index, resource_mod, nil) == :ok
    end)
    |> Enum.group_by(fn resource_mod ->
      spec(resource_mod).group || "Resources"
    end)
  end

  # LiveView render/1 cannot read socket.assigns (@socket is AssignsNotInSocket).
  defp view_assigns(%Phoenix.LiveView.Socket{
         assigns: %Phoenix.LiveView.Socket.AssignsNotInSocket{}
       }) do
    raise ArgumentError,
          "pass the LiveView assigns map from render/1, not @socket"
  end

  defp view_assigns(%Phoenix.LiveView.Socket{assigns: assigns}), do: assigns
  defp view_assigns(%{corex_admin: _} = assigns), do: assigns
  defp view_assigns(%{corex_admin_prefix: _} = assigns), do: assigns
end
