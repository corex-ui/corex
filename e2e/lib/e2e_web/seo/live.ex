defmodule E2eWeb.SEO.Live do
  @moduledoc false

  def on_mount(:default, _params, _session, socket) do
    path = request_path(socket)

    seo =
      case socket.assigns[:seo] do
        %E2eWeb.SEO{} = seo ->
          if is_binary(seo.canonical_path) and seo.canonical_path != "" do
            seo
          else
            %{seo | canonical_path: path}
          end

        _ ->
          E2eWeb.SEO.new(
            title: socket.assigns[:page_title],
            canonical_path: path,
            description: E2eWeb.SEO.default_description()
          )
      end

    {:cont, Phoenix.Component.assign(socket, :seo, seo)}
  end

  defp request_path(socket) do
    case Phoenix.LiveView.get_connect_info(socket, :uri) do
      %URI{path: path} when is_binary(path) -> path
      _ -> "/"
    end
  end
end
