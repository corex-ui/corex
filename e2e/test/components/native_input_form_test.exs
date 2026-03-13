defmodule E2eWeb.NativeInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.NativeInputModel, as: NativeInput

  feature "static form - submit empty shows flash with name and agree", %{session: session} do
    session
    |> NativeInput.goto_form(:static)
    |> NativeInput.wait(500)
    |> NativeInput.submit_form()
    |> NativeInput.wait(500)
    |> NativeInput.wait_for_redirect()
    |> NativeInput.see_flash("Submitted: name=")
  end

  feature "static form - fill all native input types then submit shows all values in flash", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:static)
    |> NativeInput.wait(500)
    |> NativeInput.fill_input_via_script("native-input-form-name", "Alice")
    |> NativeInput.fill_input_via_script("native-input-form-email", "alice@example.com")
    |> NativeInput.fill_input_via_script("native-input-form-bio", "Developer")
    |> NativeInput.fill_input_via_script("native-input-form-birth-date", "1990-01-15")
    |> NativeInput.fill_input_via_script("native-input-form-datetime", "2024-06-15T14:30")
    |> NativeInput.fill_input_via_script("native-input-form-reminder-time", "09:00")
    |> NativeInput.fill_input_via_script("native-input-form-month", "2024-06")
    |> NativeInput.fill_input_via_script("native-input-form-week", "2024-W24")
    |> NativeInput.fill_input_via_script("native-input-form-website", "https://example.com")
    |> NativeInput.fill_input_via_script("native-input-form-phone", "+1234567890")
    |> NativeInput.fill_input_via_script("native-input-form-q", "elixir")
    |> NativeInput.fill_input_via_script("native-input-form-color", "#ef4444")
    |> NativeInput.fill_input_via_script("native-input-form-count", "42")
    |> NativeInput.fill_input_via_script("native-input-form-password", "secret")
    |> NativeInput.select_option("native-input-form-role", "admin")
    |> NativeInput.select_multiple_options("native-input-form-tags", ["elixir", "phoenix"])
    |> NativeInput.click_radio("profile[size]", "m")
    |> NativeInput.click_checkbox()
    |> NativeInput.wait(200)
    |> NativeInput.submit_form()
    |> NativeInput.wait(500)
    |> NativeInput.wait_for_redirect()
    |> NativeInput.see_flash("Submitted:")
    |> NativeInput.see_flash("name=")
  end

  feature "live form - submit without required fields shows validation errors", %{
    session: session
  } do
    session =
      session
      |> NativeInput.goto_form(:live)
      |> NativeInput.wait(500)
      |> NativeInput.submit_form(:live)
      |> NativeInput.wait(500)

    assert has_text?(session, "can't be blank")
  end

  feature "live form - fill all native input types then submit shows all values in toast", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.wait(500)
    |> NativeInput.fill_input_via_script("native-input-form-name", "Alice")
    |> NativeInput.fill_input_via_script("native-input-form-email", "alice@example.com")
    |> NativeInput.fill_input_via_script("native-input-form-bio", "Developer")
    |> NativeInput.fill_input_via_script("native-input-form-birth-date", "1990-01-15")
    |> NativeInput.fill_input_via_script("native-input-form-datetime", "2024-06-15T14:30")
    |> NativeInput.fill_input_via_script("native-input-form-reminder-time", "09:00")
    |> NativeInput.fill_input_via_script("native-input-form-month", "2024-06")
    |> NativeInput.fill_input_via_script("native-input-form-week", "2024-W24")
    |> NativeInput.fill_input_via_script("native-input-form-website", "https://example.com")
    |> NativeInput.fill_input_via_script("native-input-form-phone", "+1234567890")
    |> NativeInput.fill_input_via_script("native-input-form-q", "elixir")
    |> NativeInput.fill_input_via_script("native-input-form-color", "#ef4444")
    |> NativeInput.fill_input_via_script("native-input-form-count", "42")
    |> NativeInput.fill_input_via_script("native-input-form-password", "secret")
    |> NativeInput.select_option("native-input-form-role", "admin")
    |> NativeInput.select_multiple_options("native-input-form-tags", ["elixir", "phoenix"])
    |> NativeInput.click_radio("profile[size]", "m")
    |> NativeInput.click_checkbox()
    |> NativeInput.wait(200)
    |> NativeInput.submit_form(:live)
    |> NativeInput.wait(1500)
    |> NativeInput.see_flash("Submitted:")
    |> NativeInput.see_flash("name=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> NativeInput.goto_form(:static)
    |> NativeInput.wait(500)
    |> NativeInput.check_accessibility()
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.wait(500)
    |> NativeInput.check_accessibility()
  end
end
