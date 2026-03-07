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
    |> NativeInput.see_flash("Submitted: name=")
  end

  feature "static form - fill name email date time select checkbox then submit", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:static)
    |> NativeInput.wait(500)
    |> NativeInput.fill_input("native-input-form-name", "Alice")
    |> NativeInput.fill_input("native-input-form-email", "alice@example.com")
    |> NativeInput.fill_input("native-input-form-birth-date", "1990-01-15")
    |> NativeInput.fill_input("native-input-form-reminder-time", "09:00")
    |> NativeInput.select_option("native-input-form-role", "admin")
    |> NativeInput.click_checkbox()
    |> NativeInput.wait(200)
    |> NativeInput.submit_form()
    |> NativeInput.wait(1000)
    |> NativeInput.see_flash("Submitted: name=Alice")
    |> NativeInput.see_flash("agree=true")
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

  feature "live form - fill required fields and submit shows success", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.wait(500)
    |> NativeInput.fill_input("profile_name", "Bob")
    |> NativeInput.fill_input("profile_email", "bob@example.com")
    |> NativeInput.click_checkbox()
    |> NativeInput.wait(200)
    |> NativeInput.submit_form(:live)
    |> NativeInput.wait(1000)
    |> NativeInput.see_submitted_value("name", "Bob")
    |> NativeInput.see_submitted_value("agree", "true")
  end

  feature "live form - fill all fields and submit", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.wait(500)
    |> NativeInput.fill_input("profile_name", "Carol")
    |> NativeInput.fill_input("profile_email", "carol@example.com")
    |> NativeInput.fill_input("profile_birth_date", "1985-06-20")
    |> NativeInput.fill_input("profile_reminder_time", "14:30")
    |> NativeInput.select_option("native-input-form-role", "user")
    |> NativeInput.click_checkbox()
    |> NativeInput.wait(200)
    |> NativeInput.submit_form(:live)
    |> NativeInput.wait(1000)
    |> NativeInput.see_submitted_value("name", "Carol")
    |> NativeInput.see_submitted_value("role", "user")
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
