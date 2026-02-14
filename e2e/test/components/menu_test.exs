defmodule E2eWeb.MenuTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.MenuModel, as: Menu

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Menu has no A11y violations", %{session: session} do
      session
      |> Menu.goto(@mode)
      |> Menu.check_accessibility()
    end
  end
end
