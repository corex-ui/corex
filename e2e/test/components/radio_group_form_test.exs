defmodule E2eWeb.RadioGroupFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.RadioGroupModel, as: RadioGroup

  feature "static form - submit without selection shows validation error", %{session: session} do
    session =
      session
      |> RadioGroup.goto_form(:static)
      |> RadioGroup.wait_for_has(css("#radio-group-form-page"), timeout: 15_000)
      |> RadioGroup.submit_form(:static, :ecto)

    assert_has(
      session,
      Wallaby.Query.css(
        ~S|#radio-group-form-ecto [data-scope="radio-group"][data-part="error"]|,
        text: "can't be blank"
      )
    )

    refute_has(session, Wallaby.Query.text("Submitted: choice="))
  end

  feature "static form - select option then submit includes choice", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.wait_for_has(css("#radio-group-form-page"), timeout: 15_000)
    |> RadioGroup.click_item_in_section("radio-group-form-ecto", "duis")
    |> RadioGroup.submit_form(:static, :ecto)
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
      |> RadioGroup.submit_form(:live, :ecto)

    refute_has(session, Wallaby.Query.text("choice=b"))
    assert_has(session, Wallaby.Query.css("#radio-group-live-form-ecto", text: "Choose one"))
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> RadioGroup.goto_form(:live)
    |> RadioGroup.wait_for_has(css("#radio-group-form-live-page"), timeout: 15_000)
    |> RadioGroup.check_accessibility()
  end
end
