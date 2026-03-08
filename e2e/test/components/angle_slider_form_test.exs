defmodule E2eWeb.AngleSliderFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.AngleSliderModel, as: AngleSlider

  feature "static form - submit includes angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait(500)
    |> AngleSlider.submit_form()
    |> AngleSlider.wait(500)
    |> AngleSlider.see_flash("Submitted: angle=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait(500)
    |> AngleSlider.check_accessibility()
  end

  feature "live form - submit includes angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait(500)
    |> AngleSlider.submit_form(:live)
    |> AngleSlider.wait(2000)
    |> AngleSlider.see_flash("angle=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait(500)
    |> AngleSlider.check_accessibility()
  end
end
