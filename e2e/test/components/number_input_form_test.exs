defmodule E2eWeb.NumberInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.NumberInputModel, as: NumberInput

  feature "static form - submit empty includes default value", %{session: session} do
    session
    |> NumberInput.goto_form(:static, :native)
    |> NumberInput.submit_form(:static, :native)
    |> NumberInput.wait_for_redirect()
    |> NumberInput.see_flash("Submitted: value=1234")
  end

  feature "static form - fill value then submit includes value", %{session: session} do
    session
    |> NumberInput.goto_form(:static, :native)
    |> NumberInput.fill_number_input("42", :static, :native)
    |> NumberInput.submit_form(:static, :native)
    |> NumberInput.wait_for_redirect()
    |> NumberInput.see_flash("Submitted: value=42")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> NumberInput.goto_form(:static)
    |> NumberInput.check_accessibility()
  end

  feature "live form - submit default value", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.submit_form(:live)
    |> NumberInput.see_flash("1234")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.check_accessibility()
  end

  feature "controller ecto validate form - grouped display submits canonical value", %{
    session: session
  } do
    session
    |> NumberInput.goto_form(:static, :ecto)
    |> NumberInput.wait_root_number_input_ready("number-input-form-ecto_value")
    |> NumberInput.assert_hidden_submit_value("number-input-form-ecto_value", "1234")
    |> NumberInput.refute_number_input_field_error("number-input-form-ecto_value")
  end

  feature "static phoenix form - increment updates hidden submit value", %{session: session} do
    session =
      session
      |> NumberInput.goto_form(:static, :phoenix)
      |> NumberInput.wait_root_number_input_ready("number-input-form-phoenix_value")

    session
    |> NumberInput.click_increment_in_section("number-input-form-phoenix")
    |> NumberInput.wait(300)

    assert NumberInput.hidden_submit_value_at_host(session, "number-input-form-phoenix_value") ==
             "1235"
  end

  feature "static ecto form - increment updates hidden submit value", %{session: session} do
    session =
      session
      |> NumberInput.goto_form(:static, :ecto)
      |> NumberInput.wait_root_number_input_ready("number-input-form-ecto_value")

    session
    |> NumberInput.click_increment_in_section("number-input-form-ecto")
    |> NumberInput.wait(300)

    assert NumberInput.hidden_submit_value_at_host(session, "number-input-form-ecto_value") ==
             "1235"
  end

  feature "live ecto validate form - initial value is valid", %{session: session} do
    session
    |> NumberInput.goto_form(:live)
    |> NumberInput.wait_root_number_input_ready("number-input-live-form-ecto_value")
    |> NumberInput.assert_hidden_submit_value("number-input-live-form-ecto_value", "1234")
    |> NumberInput.refute_number_input_field_error("number-input-live-form-ecto_value")
  end
end
