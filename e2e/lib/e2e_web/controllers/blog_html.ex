defmodule E2eWeb.BlogHTML do
  use E2eWeb, :html

  import E2eWeb.BlogPage

  embed_templates("blog_html/*")
end
