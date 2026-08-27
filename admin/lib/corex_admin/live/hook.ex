defmodule CorexAdmin.Live.Hook do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [attach_hook: 4, push_navigate: 2]

  alias CorexAdmin.Live.Helpers

  def on_mount({:init, admin, configured_path}, _params, _session, socket) do
    socket =
      socket
      |> assign(:corex_admin, admin)
      |> assign(:corex_admin_configured_path, configured_path)
      |> assign(:corex_admin_prefix, configured_path)
      |> attach_hook(:corex_admin_prefix, :handle_params, &assign_prefix/3)
      |> attach_hook(:corex_admin_nav, :handle_event, &handle_nav/3)

    {:cont, socket}
  end

  defp assign_prefix(_params, uri, socket) do
    configured = socket.assigns.corex_admin_configured_path
    request_path = uri_path(uri)
    prefix = prefix_from_uri(request_path, configured)
    {:cont, assign(socket, :corex_admin_prefix, prefix)}
  end

  defp handle_nav("nav", params, socket) do
    {:halt, navigate_from_tree(socket, params)}
  end

  defp handle_nav(_event, _params, socket), do: {:cont, socket}

  defp navigate_from_tree(socket, params) do
    slug = nav_slug(params)

    if nav_item?(params) and is_binary(slug) do
      case Helpers.fetch_resource(socket, slug) do
        {:ok, resource_mod} ->
          push_navigate(socket, to: Helpers.resource_path(socket, Helpers.spec(resource_mod)))

        _ ->
          socket
      end
    else
      socket
    end
  end

  defp nav_item?(params) do
    Map.get(params, "isItem") in [true, "true"]
  end

  defp nav_slug(%{"selectedValue" => [slug | _]}) when is_binary(slug), do: slug
  defp nav_slug(%{"selectedValue" => slug}) when is_binary(slug), do: slug
  defp nav_slug(_), do: nil

  defp uri_path(uri) when is_binary(uri) do
    case URI.parse(uri) do
      %URI{path: path} when is_binary(path) and path != "" -> path
      _ -> "/"
    end
  end

  defp uri_path(_), do: "/"

  defp prefix_from_uri(request_path, configured) do
    case String.split(request_path, configured, parts: 2) do
      [before, _rest] -> before <> configured
      _ -> configured
    end
  end
end
