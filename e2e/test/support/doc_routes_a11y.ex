defmodule E2eWeb.DocRoutesA11y do
  @moduledoc false

  import Wallaby.Browser
  import Wallaby.Query

  alias E2eWeb.AccordionModel, as: Accordion
  alias E2eWeb.SiteModel

  def assert_page(path, ready, export, session) do
    ready_query = css(ready, visible: :any)
    accordion_wait = accordion_wait_selector(path, ready)

    session =
      session
      |> visit("/en")
      |> set_cookie("phx_export", export, path: "/")
      |> SiteModel.visit_ready(path, ready_query)
      |> then(fn sess ->
        if accordion_wait do
          Accordion.wait_root_no_loading(sess, accordion_wait)
        else
          sess
        end
      end)

    SiteModel.check_accessibility(session, filter: E2eWeb.A11yDocPageFilter)
  end

  defp accordion_wait_selector("/en/accordion/style", _ready), do: "#my-accordion"

  defp accordion_wait_selector(path, ready) do
    if String.contains?(path, "/accordion/"), do: ready, else: nil
  end
end
