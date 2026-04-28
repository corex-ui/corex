defmodule E2eWeb.AngleSliderFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.AngleSliderModel, as: AngleSlider

  feature "static form - submit default includes angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
    |> AngleSlider.submit_form()
    |> AngleSlider.see_flash("Submitted: angle=")
  end

  feature "static form - set angle then submit includes angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
    |> AngleSlider.set_angle_value(90)
    |> AngleSlider.submit_form()
    |> AngleSlider.see_flash("angle=90")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> AngleSlider.goto_form(:static)
    |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
    |> AngleSlider.check_accessibility()
  end

  feature "live form - submit default angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait_for_has(css("#angle-slider-form-live-page"), timeout: 15_000)
    |> AngleSlider.submit_form(:live)
    |> AngleSlider.see_flash("Submitted: angle=", timeout: 20_000, interval: 200)
  end

  feature "live form - set angle then submit shows submitted angle", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait_for_has(css("#angle-slider-form-live-page"), timeout: 15_000)
    |> AngleSlider.set_angle_value(90, :live)
    |> AngleSlider.submit_form(:live)
    |> AngleSlider.see_flash("Submitted: angle=90", timeout: 20_000, interval: 200)
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> AngleSlider.goto_form(:live)
    |> AngleSlider.wait_for_has(css("#angle-slider-form-live-page"), timeout: 15_000)
    |> AngleSlider.check_accessibility()
  end
end
