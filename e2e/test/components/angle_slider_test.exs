defmodule E2eWeb.AngleSliderTest do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  alias E2eWeb.AngleSliderModel, as: AngleSlider

  for mode <- [:static, :live] do
    @mode mode

    feature "#{@mode} - Angle slider has no A11y violations", %{session: session} do
      session
      |> AngleSlider.goto(@mode)
      |> AngleSlider.check_accessibility()
    end
  end
end
