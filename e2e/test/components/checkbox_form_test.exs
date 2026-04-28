defmodule E2eWeb.CheckboxFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.CheckboxModel, as: Checkbox

  feature "static form - submit unchecked includes terms=false", %{session: session} do
    session
    |> Checkbox.goto_form(:static)
    |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
    |> Checkbox.submit_form()
    |> Checkbox.see_flash("Submitted: terms=")
  end

  feature "static form - click checkbox then submit includes terms", %{session: session} do
    session
    |> Checkbox.goto_form(:static)
    |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
    |> Checkbox.click_checkbox()
    |> Checkbox.submit_form()
    |> Checkbox.see_flash("Submitted: terms=")
  end

  feature "live form (controlled) - submit without checking terms does not show success", %{
    session: session
  } do
    session =
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
      |> Checkbox.submit_form(:live)

    refute_has(session, Wallaby.Query.text("terms=true"))
    assert_has(session, css("#checkbox-form-live-terms", visible: true))
  end

  feature "live form (controlled) - check terms then submit shows success", %{session: session} do
    session
    |> Checkbox.goto_form(:live)
    |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
    |> Checkbox.click_checkbox(:live)
    |> Checkbox.submit_form(:live)
    |> Checkbox.see_flash("terms=true")
  end

  feature "static form - checkbox form has no A11y violations", %{session: session} do
    session
    |> Checkbox.goto_form(:static)
    |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
    |> Checkbox.check_accessibility()
  end

  feature "live form - checkbox form has no A11y violations", %{session: session} do
    session
    |> Checkbox.goto_form(:live)
    |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
    |> Checkbox.check_accessibility()
  end
end
