defmodule E2eWeb.CheckboxFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.CheckboxModel, as: Checkbox

  describe "static controller" do
    feature "phoenix form submit unchecked shows terms=false", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_static_form_checkbox_ready("checkbox-form-phoenix_terms")
      |> Checkbox.submit_form()
      |> Checkbox.see_flash("terms=false")
    end

    feature "phoenix form check then submit shows terms=true", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.click_checkbox()
      |> Checkbox.submit_form()
      |> Checkbox.see_flash("terms=true")
    end

    feature "ecto form submit unchecked shows validation error", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.submit_form(:static_ecto)
      |> Checkbox.see_error("must be accepted to continue", :static_ecto)
    end

    feature "ecto form check then submit shows terms=true", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.click_checkbox(:static_ecto)
      |> Checkbox.submit_form(:static_ecto)
      |> Checkbox.see_flash("terms=true")
    end

    feature "native form submit unchecked shows terms=false", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.submit_form(:static_native)
      |> Checkbox.see_flash("terms=false")
    end

    feature "native form check then submit shows terms=true", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.click_checkbox(:static_native)
      |> Checkbox.submit_form(:static_native)
      |> Checkbox.see_flash("terms=true")
    end

    feature "checkbox form has no A11y violations", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.check_accessibility()
    end
  end

  describe "live" do
    feature "phoenix form submit unchecked then checked shows correct toast", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.submit_form(:live)
      |> Checkbox.see_flash("terms=false")
      |> Checkbox.click_checkbox(:live)
      |> Checkbox.submit_form(:live)
      |> Checkbox.see_flash("terms=true")
    end

    feature "ecto form submit unchecked shows validation error", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.click_live_strict_submit()
      |> Checkbox.see_error("must be accepted to continue", :live)
    end

    feature "ecto form check then submit shows terms=true", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.click_checkbox_in_section("checkbox-live-form-ecto_terms")
      |> Checkbox.click_live_strict_submit()
      |> Checkbox.see_flash("terms=true")
    end

    feature "checkbox live form has no A11y violations", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.check_accessibility()
    end
  end
end
