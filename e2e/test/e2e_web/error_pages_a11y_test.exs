defmodule E2eWeb.ErrorPagesA11yTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  import Wallaby.Browser, only: [visit: 2]

  @missing_404_path "/en/nonexistent"

  setup do
    Localize.put_locale(:en)
    :ok
  end

  feature "404 page has no a11y violations", %{session: session} do
    session
    |> visit(@missing_404_path)
    |> E2eWeb.Model.wait(500)
    |> A11yAudit.Wallaby.assert_no_violations()
  end
end
