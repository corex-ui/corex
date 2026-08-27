defmodule CorexAdmin.Live.Hook do
  @moduledoc false

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [attach_hook: 4, push_navigate: 2]

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
    path = nav_path(params)
    prefix = socket.assigns.corex_admin_prefix

    if nav_item?(params) and allowed_admin_path?(path, prefix) do
      push_navigate(socket, to: path)
    else
      socket
    end
  end

  defp nav_item?(params) do
    Map.get(params, "isItem") in [true, "true"]
  end

  defp nav_path(%{"selectedValue" => [path | _]}) when is_binary(path), do: path
  defp nav_path(%{"selectedValue" => path}) when is_binary(path), do: path
  defp nav_path(_), do: nil

  defp allowed_admin_path?(path, prefix) when is_binary(path) and is_binary(prefix) do
    normalized = path |> String.split("?", parts: 2) |> hd()

    String.starts_with?(normalized, "/") and
      not String.contains?(normalized, "..") and
      (normalized == prefix or String.starts_with?(normalized, prefix <> "/"))
  end

  defp allowed_admin_path?(_path, _prefix), do: false

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
