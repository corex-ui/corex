defmodule E2eWeb.DocRoutesA11yTest do
  @moduledoc """
  One axe scan per doc route (see `E2eWeb.DocA11yRoutes`).

  Run a subset instead of the full suite:

      mix test test/e2e_web/doc_routes_a11y_test.exs --only doc_a11y_component:accordion
      mix test test/e2e_web/doc_routes_a11y_test.exs --only doc_a11y_page:style
      mix test test/e2e_web/doc_routes_a11y_test.exs -n "accordion/style"
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag timeout: 300_000

  import E2eWeb.A11yExport

  alias E2eWeb.DocA11yRoutes
  alias E2eWeb.DocRoutesA11y

  for {path, ready} <- DocA11yRoutes.all(), export <- exports() do
    component = DocA11yRoutes.component_slug(path)
    page = DocA11yRoutes.page_key(path)

    @path path
    @ready ready
    @export export
    @tag :doc_a11y
    @tag :a11y_doc
    @tag doc_a11y_component: component
    @tag doc_a11y_page: page

    feature "a11y doc #{@path} #{@ready} (#{@export} export)", %{session: session} do
      DocRoutesA11y.assert_page(@path, @ready, @export, session)
    end
  end
end
