defmodule E2eWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use E2eWeb, :html
  import E2eWeb.DemoPage

  embed_templates "page_html/*"

  embed_templates "page_html/accordion/*"
  embed_templates "page_html/tree_view/*"
end
