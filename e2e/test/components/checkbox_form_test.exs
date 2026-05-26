defmodule E2eWeb.CheckboxFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.CheckboxModel, as: Checkbox

  describe "static controller" do
    feature "phoenix form submit unchecked shows terms=false", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.wait_static_form_checkbox_ready("checkbox-form-phoenix_terms")
      |> Checkbox.submit_form()
      |> Checkbox.see_flash("terms=false")
    end

    feature "phoenix form check then submit shows terms=true", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.click_checkbox()
      |> Checkbox.submit_form()
      |> Checkbox.see_flash("terms=true")
    end

    feature "ecto form submit unchecked shows validation error", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.submit_form(:static_ecto)
      |> Checkbox.see_error("must be accepted to continue")
    end

    feature "ecto form check then submit shows terms=true", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.click_checkbox(:static_ecto)
      |> Checkbox.submit_form(:static_ecto)
      |> Checkbox.see_flash("terms=true")
    end

    feature "native form submit unchecked shows terms=false", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.submit_form(:static_native)
      |> Checkbox.see_flash("terms=false")
    end

    feature "native form check then submit shows terms=true", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.click_checkbox(:static_native)
      |> Checkbox.submit_form(:static_native)
      |> Checkbox.see_flash("terms=true")
    end

    feature "checkbox form has no A11y violations", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.check_accessibility()
    end
  end

  describe "live" do
    feature "phoenix form submit unchecked then checked shows correct toast", %{session: session} do
      session =
        session
        |> Checkbox.goto_form(:live)
        |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)

      session = Checkbox.submit_form(session, :live)
      Checkbox.see_flash(session, "terms=false")

      session =
        session
        |> Checkbox.click_checkbox(:live)
        |> Checkbox.submit_form(:live)

      Checkbox.see_flash(session, "terms=true")
    end

    feature "ecto form submit unchecked shows validation error", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
      |> Checkbox.click_live_strict_submit()
      |> Checkbox.see_error("must be accepted to continue")
    end

    feature "ecto form check then submit shows terms=true", %{session: session} do
      session =
        session
        |> Checkbox.goto_form(:live)
        |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)

      session
      |> Checkbox.click_checkbox_in_section("checkbox-live-form-ecto_terms")
      |> Checkbox.click_live_strict_submit()
      |> Checkbox.see_flash("terms=true")
    end

    feature "checkbox live form has no A11y violations", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
      |> Checkbox.check_accessibility()
    end
  end
end
