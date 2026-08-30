defmodule CorexAdmin.Live.Hook do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [attach_hook: 4]

  def on_mount({:init, admin, configured_path}, _params, _session, socket) do
    socket =
      socket
      |> assign(:corex_admin, admin)
      |> assign(:corex_admin_configured_path, configured_path)
      |> assign(:corex_admin_prefix, configured_path)
      |> assign(:corex_admin_path, configured_path)
      |> attach_hook(:corex_admin_prefix, :handle_params, &assign_prefix/3)

    {:cont, socket}
  end

  defp assign_prefix(_params, uri, socket) do
    configured = socket.assigns.corex_admin_configured_path
    request_path = uri_path(uri)
    prefix = prefix_from_uri(request_path, configured)

    {:cont,
     socket
     |> assign(:corex_admin_prefix, prefix)
     |> assign(:corex_admin_path, request_path)}
  end

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
