defmodule E2eWeb.NavigateTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.NavigateModel, as: Navigate

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Navigate has no A11y violations", %{session: session} do
      session
      |> Navigate.goto(@mode)
      |> Navigate.check_accessibility()
    end
  end
end
