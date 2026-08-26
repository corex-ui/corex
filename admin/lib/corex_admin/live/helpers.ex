defmodule CorexAdmin.Live.Helpers do
  @moduledoc false

  import Phoenix.LiveView, only: [put_flash: 3, push_navigate: 2]

  require Logger

  alias CorexAdmin.ListOpts
  alias CorexAdmin.Policy
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

  def unauthorized(socket, reason \\ :unauthorized) do
    message =
      case reason do
        :unauthorized -> "You are not authorized to perform this action."
        :not_found -> "Unknown resource."
        other when is_binary(other) -> other
        _ -> "You are not authorized to perform this action."
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

  def not_found(socket) do
    socket
    |> put_flash(:error, "Record not found.")
    |> push_navigate(to: home_path(socket))
  end

  def home_path(socket_or_assigns), do: view_assigns(socket_or_assigns).corex_admin_prefix

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

  def record_title(%Spec{title_field: field} = spec, record) when is_atom(field) do
    case Map.get(record, field) do
      value when value in [nil, ""] -> record_id(spec, record)
      value -> to_string(value)
    end
  end

  def record_title(spec, record), do: record_id(spec, record)

  def index_fields(%Spec{fields: fields}) do
    Enum.filter(fields, & &1.index)
  end

  def show_fields(%Spec{fields: fields}) do
    Enum.filter(fields, & &1.show)
  end

  def form_fields(%Spec{fields: fields}) do
    Enum.filter(fields, & &1.writable)
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
