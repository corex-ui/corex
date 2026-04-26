defmodule E2eWeb.PathLive do
  use Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    _ =
      case Localize.Plug.put_locale_from_session(session, gettext: E2eWeb.Gettext) do
        {:ok, _} -> :ok
        {:error, _} -> :ok
      end

    socket =
      socket
      |> Phoenix.Component.assign(:path, "")
      |> attach_hook(:e2e_path_from_uri, :handle_params, &assign_path_from_uri/3)

    {:cont, socket}
  end

  defp assign_path_from_uri(_params, uri, socket) do
    raw = request_path_for_handle_params(uri)
    path = E2eWeb.Path.strip_after_locale(raw)
    {:cont, Phoenix.Component.assign(socket, :path, path)}
  end

  defp request_path_for_handle_params(%URI{path: p} = _) when is_binary(p) and p != "", do: p
  defp request_path_for_handle_params(%URI{}), do: "/"

  defp request_path_for_handle_params(url) when is_binary(url) do
    case URI.parse(url) do
      %URI{path: p} when is_binary(p) and p != "" -> p
      _ -> "/"
    end
  end

  defp request_path_for_handle_params(_), do: "/"
end
