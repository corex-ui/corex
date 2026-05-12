defmodule E2eWeb.CheckboxFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query
  import Wallaby.Browser

  alias E2eWeb.CheckboxModel, as: Checkbox

  describe "static" do
    feature "submit unchecked includes terms=false", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.submit_form()
      |> Checkbox.see_flash("Submitted: terms=")
    end

    feature "click native checkbox then submit includes terms", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.click_checkbox()
      |> Checkbox.submit_form()
      |> Checkbox.see_flash("Submitted: terms=")
    end

    feature "changeset section submits when terms accepted", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.wait_static_form_checkbox_ready("checkbox-form-changeset")
      |> click(css("#checkbox-form-changeset [data-scope='checkbox'][data-part='control']"))
      |> Checkbox.submit_static_changeset()
      |> Checkbox.see_flash("Submitted (changeset): terms=true")
    end

    feature "validate section rejects submit when terms not accepted", %{session: session} do
      session =
        session
        |> Checkbox.goto_form(:static)
        |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
        |> Checkbox.wait_static_form_checkbox_ready("checkbox-form-validate")
        |> Checkbox.submit_static_validate()

      assert_has(session, css("#checkbox-form-validate", text: "must be accepted"))
    end

    feature "checkbox form has no A11y violations", %{session: session} do
      session
      |> Checkbox.goto_form(:static)
      |> Checkbox.wait_for_has(css("#checkbox-form-page"), timeout: 15_000)
      |> Checkbox.check_accessibility()
    end
  end

  describe "live" do
    feature "submit without checking terms does not show success", %{session: session} do
      session =
        session
        |> Checkbox.goto_form(:live)
        |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
        |> Checkbox.submit_form(:live)

      refute_has(session, Wallaby.Query.text("terms=true"))
      assert_has(session, css("#checkbox-form-live-terms", visible: true))
    end

    feature "check terms then submit shows success", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
      |> Checkbox.click_checkbox(:live)
      |> Checkbox.submit_form(:live)
      |> Checkbox.see_flash("terms=true")
    end

    feature "strict validate section rejects submit without acceptance", %{session: session} do
      session =
        session
        |> Checkbox.goto_form(:live)
        |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
        |> Checkbox.click_live_strict_submit()

      assert_has(session, css("#checkbox-live-form-validate", text: "must be accepted"))
    end

    feature "checkbox live form has no A11y violations", %{session: session} do
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.wait_for_has(css("#checkbox-form-live-page"), timeout: 15_000)
      |> Checkbox.check_accessibility()
    end
  end
end
