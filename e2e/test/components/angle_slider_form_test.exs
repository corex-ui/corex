defmodule E2eWeb.AngleSliderFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.AngleSliderModel, as: AngleSlider

  describe "static" do
    feature "submit default includes angle", %{session: session} do
      session
      |> AngleSlider.goto_form(:static)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
      |> AngleSlider.submit_form()
      |> AngleSlider.see_flash("Submitted: angle=")
    end

    feature "set angle then submit includes angle", %{session: session} do
      session
      |> AngleSlider.goto_form(:static)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
      |> AngleSlider.set_angle_value(90)
      |> AngleSlider.submit_form()
      |> AngleSlider.see_flash("angle=90")
    end

    feature "changeset section submits default angle", %{session: session} do
      session
      |> AngleSlider.goto_form(:static)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
      |> AngleSlider.wait_static_changeset_angle_slider_ready()
      |> AngleSlider.submit_static_changeset()
      |> AngleSlider.see_flash("Submitted: angle=0")
    end

    feature "validate section submits default valid angle", %{session: session} do
      session
      |> AngleSlider.goto_form(:static)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
      |> AngleSlider.wait_static_validate_angle_slider_ready()
      |> AngleSlider.submit_static_validate()
      |> AngleSlider.see_flash("Submitted: angle=0")
    end

    feature "has no A11y violations", %{session: session} do
      session
      |> AngleSlider.goto_form(:static)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-page"), timeout: 15_000)
      |> AngleSlider.check_accessibility()
    end
  end

  describe "live" do
    feature "submit default angle", %{session: session} do
      session
      |> AngleSlider.goto_form(:live)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-live-page"), timeout: 15_000)
      |> AngleSlider.submit_form(:live)
      |> AngleSlider.see_flash("Submitted: angle=")
    end

    feature "set angle then submit shows submitted angle", %{session: session} do
      session
      |> AngleSlider.goto_form(:live)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-live-page"), timeout: 15_000)
      |> AngleSlider.set_angle_value(90, :live)
      |> AngleSlider.submit_form(:live)
      |> AngleSlider.see_flash("Submitted: angle=90")
    end

    feature "validate section submits default angle", %{session: session} do
      session
      |> AngleSlider.goto_form(:live)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-live-page"), timeout: 15_000)
      |> AngleSlider.wait_live_validate_angle_section_ready()
      |> AngleSlider.submit_live_validate()
      |> AngleSlider.see_flash("Submitted: angle=0")
    end

    feature "has no A11y violations", %{session: session} do
      session
      |> AngleSlider.goto_form(:live)
      |> AngleSlider.wait_for_has(css("#angle-slider-form-live-page"), timeout: 15_000)
      |> AngleSlider.check_accessibility()
    end
  end
end
