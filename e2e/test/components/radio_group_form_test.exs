defmodule E2eWeb.RadioGroupFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.RadioGroupModel, as: RadioGroup

  feature "static form - submit without selection shows validation error", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.submit_form(:static, :ecto)
    |> RadioGroup.wait_for_ecto_form_error()
    |> RadioGroup.refute_success_toast("Submitted: choice=")
  end

  feature "static form - select option then submit includes choice", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.click_item_in_section("radio-group-form-ecto", "duis")
    |> RadioGroup.submit_form(:static, :ecto)
    |> RadioGroup.wait_for_redirect()
    |> RadioGroup.see_flash("Submitted: choice=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.check_accessibility()
  end

  feature "live form - submit without selection does not show success", %{session: session} do
    session
    |> RadioGroup.goto_form(:live)
    |> RadioGroup.submit_form(:live, :ecto)
    |> RadioGroup.refute_success_toast("choice=b")
    |> RadioGroup.wait_for_live_form_unchanged()
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> RadioGroup.goto_form(:live)
    |> RadioGroup.check_accessibility()
  end
end
