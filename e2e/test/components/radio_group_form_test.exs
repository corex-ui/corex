defmodule E2eWeb.RadioGroupFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.RadioGroupModel, as: RadioGroup

  feature "static form - submit without selection includes empty choice", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.wait_for_has(css("#radio-group-form-page"), timeout: 15_000)
    |> RadioGroup.submit_form()
    |> RadioGroup.wait_for_redirect()
    |> RadioGroup.see_flash("Submitted: choice=")
  end

  feature "static form - select option then submit includes choice", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.wait_for_has(css("#radio-group-form-page"), timeout: 15_000)
    |> RadioGroup.click_radio_native("b")
    |> RadioGroup.submit_form()
    |> RadioGroup.wait_for_redirect()
    |> RadioGroup.see_flash("Submitted: choice=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.wait_for_has(css("#radio-group-form-page"), timeout: 15_000)
    |> RadioGroup.check_accessibility()
  end

  feature "live form - submit without selection does not show success", %{session: session} do
    session =
      session
      |> RadioGroup.goto_form(:live)
      |> RadioGroup.wait_for_has(css("#radio-group-form-live-page"), timeout: 15_000)
      |> RadioGroup.submit_form(:live)

    refute_has(session, Wallaby.Query.text("choice=b"))
    assert_has(session, Wallaby.Query.css("#radio-group-live-form-changeset", text: "Choose one"))
  end

  feature "live form - select option then submit shows success", %{session: session} do
    session
    |> RadioGroup.goto_form(:live)
    |> RadioGroup.wait_for_has(css("#radio-group-form-live-page"), timeout: 15_000)
    |> RadioGroup.click_radio_live("duis")
    |> RadioGroup.submit_form(:live)
    |> RadioGroup.see_flash("Submitted: choice=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> RadioGroup.goto_form(:live)
    |> RadioGroup.wait_for_has(css("#radio-group-form-live-page"), timeout: 15_000)
    |> RadioGroup.check_accessibility()
  end
end
