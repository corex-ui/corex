defmodule E2eWeb.CheckboxFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.CheckboxModel, as: Checkbox

  feature "static form - submit unchecked includes terms=false", %{session: session} do
    session
    |> Checkbox.goto_form(:static)
    |> Checkbox.wait(500)
    |> Checkbox.submit_form()
    |> Checkbox.wait(500)
    |> Checkbox.see_flash("Submitted: terms=")
  end

  feature "static form - click checkbox then submit includes terms", %{session: session} do
    session
    |> Checkbox.goto_form(:static)
    |> Checkbox.wait(500)
    |> Checkbox.click_checkbox()
    |> Checkbox.wait(200)
    |> Checkbox.submit_form()
    |> Checkbox.wait(500)
    |> Checkbox.see_flash("Submitted: terms=")
  end

  feature "live form (controlled) - submit without checking terms does not show success", %{
    session: session
  } do
    session =
      session
      |> Checkbox.goto_form(:live)
      |> Checkbox.wait(500)
      |> Checkbox.submit_form(:live)
      |> Checkbox.wait(1500)

    refute_has(session, Wallaby.Query.text("terms=true"))
    assert_has(session, Wallaby.Query.text("Accept terms"))
  end

  feature "live form (controlled) - check terms then submit shows success", %{session: session} do
    session
    |> Checkbox.goto_form(:live)
    |> Checkbox.wait(500)
    |> Checkbox.click_checkbox()
    |> Checkbox.wait(200)
    |> Checkbox.submit_form(:live)
    |> Checkbox.wait(1500)
    |> Checkbox.see_flash("terms=true")
  end

  feature "static form - checkbox form has no A11y violations", %{session: session} do
    session
    |> Checkbox.goto_form(:static)
    |> Checkbox.wait(500)
    |> Checkbox.check_accessibility()
  end

  feature "live form - checkbox form has no A11y violations", %{session: session} do
    session
    |> Checkbox.goto_form(:live)
    |> Checkbox.wait(500)
    |> Checkbox.check_accessibility()
  end
end
