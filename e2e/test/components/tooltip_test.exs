defmodule E2eWeb.TooltipTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.TooltipModel, as: Tooltip

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Tooltip has no A11y violations", %{session: session} do
      session
      |> Tooltip.goto(@mode)
      |> Tooltip.wait(500)
      |> Tooltip.check_accessibility()
    end
  end
end
