defmodule E2eWeb.PagesA11yTest do
  use E2eWeb.ConnCase, async: false
  use Wallaby.Feature

  @pages [
    {"Home", "/en"},
    {"Admins", "/en/admins"},
    {"Users", "/en/users"}
  ]

  for {name, path} <- @pages do
    @name name
    @path path

    feature "#{@name} page has no A11y violations", %{session: session} do
      session
      |> Wallaby.Browser.visit(@path)
      # Wait for potential liveviews to load or UI to settle
      |> E2eWeb.Model.wait(500)
      |> A11yAudit.Wallaby.assert_no_violations()
    end
  end
end