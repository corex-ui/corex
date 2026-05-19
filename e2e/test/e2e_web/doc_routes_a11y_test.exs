defmodule E2eWeb.DocRoutesA11yTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag timeout: 300_000

  import Wallaby.Query

  alias E2eWeb.AccordionModel, as: Accordion
  alias E2eWeb.SiteModel

  for {path, ready} <- E2eWeb.DocA11yRoutes.all() do
    @path path
    @ready ready

    feature "a11y doc #{@path} #{@ready}", %{session: session} do
      ready_query = css(@ready, visible: :any)

      session =
        session
        |> SiteModel.visit_ready(@path, ready_query)
        |> then(fn sess ->
          if String.contains?(@path, "/accordion/") do
            Accordion.wait_root_no_loading(sess, @ready)
          else
            sess
          end
        end)

      SiteModel.check_accessibility(session)
    end
  end
end
