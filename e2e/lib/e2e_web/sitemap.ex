defmodule E2eWeb.Sitemap do
  @moduledoc false

  def urlset_xmlns do
    Application.fetch_env!(:corex_web, :sitemap_urlset_xmlns)
  end

  def urlset_open_tag do
    ~s(<urlset xmlns="#{urlset_xmlns()}">)
  end
end
