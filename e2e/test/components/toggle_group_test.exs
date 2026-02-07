defmodule E2eWeb.ToggleGroupTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.ToggleGroupModel, as: ToggleGroup

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - ToggleGroup has no A11y violations", %{session: session} do
      session
      |> ToggleGroup.goto(@mode)
      |> ToggleGroup.check_accessibility()
    end
  end
end
