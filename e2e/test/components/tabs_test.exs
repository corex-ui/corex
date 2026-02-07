defmodule E2eWeb.TabsTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.TabsModel, as: Tabs

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Tabs has no A11y violations", %{session: session} do
      session
      |> Tabs.goto(@mode)
      |> Tabs.check_accessibility()
    end
  end
end
