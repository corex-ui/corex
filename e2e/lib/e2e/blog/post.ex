defmodule E2e.Blog.Post do
  @moduledoc false

  @enforce_keys [:slug, :title, :permalink, :html, :file]
  defstruct [
    :slug,
    :title,
    :description,
    :permalink,
    :date,
    :tags,
    :html,
    :sitemap,
    :file
  ]
end
