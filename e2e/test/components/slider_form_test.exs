defmodule E2eWeb.SliderFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.SliderModel, as: Slider

  describe "static" do
    feature "submit default includes volume", %{session: session} do
      session
      |> Slider.goto_form(:static)
      |> Slider.submit_form()
      |> Slider.see_flash("Submitted: volume=")
    end

    feature "set volume then submit includes volume", %{session: session} do
      session
      |> Slider.goto_form(:static)
      |> Slider.set_volume_value(90)
      |> Slider.submit_form()
      |> Slider.see_flash("volume=90")
    end

    feature "changeset section submits default volume", %{session: session} do
      session
      |> Slider.goto_form(:static)
      |> Slider.wait_static_changeset_slider_ready()
      |> Slider.submit_static_changeset()
      |> Slider.see_flash("Submitted: volume=0")
    end

    feature "validate section submits default valid volume", %{session: session} do
      session
      |> Slider.goto_form(:static)
      |> Slider.wait_static_validate_slider_ready()
      |> Slider.submit_static_validate()
      |> Slider.see_flash("Submitted: volume=0")
    end

    feature "has no A11y violations", %{session: session} do
      session
      |> Slider.goto_form(:static)
      |> Slider.check_accessibility()
    end
  end

  describe "live" do
    feature "submit default volume", %{session: session} do
      session
      |> Slider.goto_form(:live)
      |> Slider.submit_form(:live)
      |> Slider.see_flash("Submitted: volume=")
    end

    feature "set volume then submit shows submitted volume", %{session: session} do
      session
      |> Slider.goto_form(:live)
      |> Slider.set_volume_value(90, :live)
      |> Slider.submit_form(:live)
      |> Slider.see_flash("Submitted: volume=90")
    end

    feature "validate section submits default volume", %{session: session} do
      session
      |> Slider.goto_form(:live)
      |> Slider.wait_live_validate_volume_section_ready()
      |> Slider.submit_live_validate()
      |> Slider.see_flash("Submitted: volume=0")
    end

    feature "has no A11y violations", %{session: session} do
      session
      |> Slider.goto_form(:live)
      |> Slider.check_accessibility()
    end
  end
end
