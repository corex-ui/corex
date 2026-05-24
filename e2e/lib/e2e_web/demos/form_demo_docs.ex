defmodule E2eWeb.Demos.FormDemoDocs do
  @app_root Path.expand("../../..", __DIR__)

  def source(relative_path) when is_binary(relative_path) do
    relative_path
    |> then(&Path.join(@app_root, &1))
    |> Path.expand()
    |> File.read!()
  end

  def live_form(slug) when is_binary(slug) do
    source("lib/e2e_web/live/pages_live/#{slug}_form_live.ex")
  end

  def controller_page(slug) when is_binary(slug) do
    source("lib/e2e_web/controllers/page_html/#{slug}_form_page.html.heex")
  end
end
