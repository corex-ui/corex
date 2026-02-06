defmodule E2eWeb.SelectTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.SelectModel, as: Select

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Select has no A11y violations", %{session: session} do
      session
      |> Select.goto(@mode)
      |> Select.check_accessibility()
    end
  end
end
