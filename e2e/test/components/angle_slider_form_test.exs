defmodule E2eWeb.AngleSliderFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.AngleSliderModel, as: AngleSlider

  feature "static form - submit default includes angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait(500)
    |> AngleSlider.submit_form()
    |> AngleSlider.wait(500)
    |> AngleSlider.see_flash("Submitted: angle=")
  end

  feature "static form - set angle then submit includes angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait(500)
    |> AngleSlider.set_angle_value(90)
    |> AngleSlider.wait(200)
    |> AngleSlider.submit_form()
    |> AngleSlider.wait(500)
    |> AngleSlider.see_flash("angle=90")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait(500)
    |> AngleSlider.check_accessibility()
  end

  feature "live form - submit default angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait(500)
    |> AngleSlider.submit_form(:live)
    |> AngleSlider.wait(2000)
    |> AngleSlider.see_flash("angle=")
  end

  feature "live form - set angle then submit shows submitted angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait(500)
    |> AngleSlider.set_angle_value(90)
    |> AngleSlider.wait(500)
    |> AngleSlider.submit_form(:live)
    |> AngleSlider.wait(2000)
    |> AngleSlider.see_flash("angle=90")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait(500)
    |> AngleSlider.check_accessibility()
  end
end
