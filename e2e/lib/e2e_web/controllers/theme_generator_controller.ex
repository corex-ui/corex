defmodule E2eWeb.ThemeGeneratorController do
  use E2eWeb, :controller

  @token_salt "theme_gen_export"

  def export(conn, params) do
    %{"token" => token, "kind" => kind} = params

    case Phoenix.Token.verify(E2eWeb.Endpoint, @token_salt, token, max_age: :timer.hours(1)) do
      {:ok, export_id} ->
        case :ets.lookup(:theme_generator_exports, export_id) do
          [{^export_id, workspace}] ->
            files =
              case kind do
                "json" -> E2e.ThemeGenerator.Build.collect_json_files(workspace)
                "css" -> E2e.ThemeGenerator.Build.collect_css_files(workspace)
                _ -> []
              end

            if files == [] do
              send_resp(conn, 404, "nothing to export")
            else
              entries =
                Enum.map(files, fn {rel, bin} ->
                  {String.to_charlist(String.replace(rel, "\\", "/")), bin}
                end)

              {:ok, {_name, zip}} = :zip.create(~c"export.zip", entries, [:memory])

              filename = "corex-theme-#{kind}.zip"

              conn
              |> put_resp_content_type("application/zip")
              |> put_resp_header("content-disposition", ~s(attachment; filename="#{filename}"))
              |> send_resp(200, zip)
            end

          [] ->
            send_resp(conn, 404, "expired")
        end

      {:error, _} ->
        send_resp(conn, 403, "invalid")
    end
  end
end
