defmodule E2eWeb.SharedEvents do
  @moduledoc "Event handlers shared on all LiveView modules"
  use Phoenix.LiveView

  def on_mount(:default, params, _session, socket) do
    socket =
      socket
      |> assign_locale_and_dir(params)
      |> assign_current_path(params)
      |> attach_hook(:handle_menu, :handle_event, &handle_menu_event/3)
      |> attach_hook(:locale_change, :handle_event, &handle_locale_change/3)
      |> attach_hook(:current_path, :handle_params, &assign_current_path_from_uri/3)

    {:cont, socket}
  end

  defp assign_locale_and_dir(socket, params) do
    locale = params["locale"] || "en"
    dir = if locale in Application.get_env(:corex, :rtl_locales, []), do: "rtl", else: "ltr"

    socket
    |> assign(:locale, locale)
    |> assign(:dir, dir)
  end

  defp assign_current_path(socket, params) do
    locale = params["locale"] || "en"
    path = get_connect_info(socket, :uri) |> path_from_uri()
    current_path = E2eWeb.Plugs.Locale.path_without_locale(path || "/#{locale}", locale)
    assign(socket, :current_path, current_path)
  end

  defp assign_current_path_from_uri(_params, uri, socket) do
    path = path_from_uri(uri)
    locale = socket.assigns.locale
    current_path = E2eWeb.Plugs.Locale.path_without_locale(path || "/#{locale}", locale)
    {:cont, assign(socket, :current_path, current_path)}
  end

  defp path_from_uri(nil), do: nil
  defp path_from_uri(uri) when is_binary(uri), do: URI.parse(uri).path
  defp path_from_uri(%URI{path: path}), do: path

  defp handle_menu_event("handle_menu", %{"id" => _id, "value" => value}, socket) do
    if value["isItem"] do
      {:halt, push_navigate(socket, to: Enum.at(value["selectedValue"], 0))}
    else
      {:halt, socket}
    end
  end

  defp handle_menu_event(_event, _params, socket) do
    {:cont, socket}
  end

  defp handle_locale_change("locale_change", params, socket) do
    value = params["value"] || params[:value] || []
    path = params["path"] || params[:path] || socket.assigns[:current_path] || "/"
    first = List.first(value)

    to =
      if first && String.starts_with?(first, "/") do
        first
      else
        "/#{first || "en"}#{path}"
      end

    {:halt, redirect(socket, to: to)}
  end

  defp handle_locale_change(_event, _params, socket) do
    {:cont, socket}
  end
end
