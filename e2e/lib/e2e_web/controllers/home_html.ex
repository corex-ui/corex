defmodule E2eWeb.HomeHTML do
  use E2eWeb, :html

  import E2eWeb.Home.Page, only: [page: 1]

  embed_templates("home_html/*")
end
