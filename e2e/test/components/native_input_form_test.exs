defmodule E2eWeb.NativeInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.NativeInputModel, as: NativeInput

  feature "static form - submit empty shows flash with name and agree", %{session: session} do
    session
    |> NativeInput.goto_form(:static, :native)
    |> NativeInput.submit_form(:static, :native)
    |> NativeInput.wait_for_redirect()
    |> NativeInput.see_flash("Submitted: name=")
  end

  feature "static form - fill all native input types then submit shows all values in flash", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:static, :native)
    |> NativeInput.fill_input_via_script("native-input-form-name", "Alice", :static)
    |> NativeInput.fill_input_via_script("native-input-form-email", "alice@example.com", :static)
    |> NativeInput.fill_input_via_script("native-input-form-bio", "Developer", :static)
    |> NativeInput.fill_input_via_script("native-input-form-birth-date", "1990-01-15", :static)
    |> NativeInput.fill_input_via_script(
      "native-input-form-datetime",
      "2024-06-15T14:30",
      :static
    )
    |> NativeInput.fill_input_via_script("native-input-form-reminder-time", "09:00", :static)
    |> NativeInput.fill_input_via_script("native-input-form-month", "2024-06", :static)
    |> NativeInput.fill_input_via_script("native-input-form-week", "2024-W24", :static)
    |> NativeInput.fill_input_via_script(
      "native-input-form-website",
      "https://example.com",
      :static
    )
    |> NativeInput.fill_input_via_script("native-input-form-phone", "+1234567890", :static)
    |> NativeInput.fill_input_via_script("native-input-form-q", "elixir", :static)
    |> NativeInput.fill_input_via_script("native-input-form-color", "#ef4444", :static)
    |> NativeInput.fill_input_via_script("native-input-form-count", "42", :static)
    |> NativeInput.fill_input_via_script("native-input-form-password", "secret", :static)
    |> NativeInput.select_option("native-input-form-role", "admin", :static)
    |> NativeInput.select_multiple_options(
      "native-input-form-tags",
      ["elixir", "phoenix"],
      :static
    )
    |> NativeInput.click_radio("profile[size]", "m", :static)
    |> NativeInput.click_agree(:static)
    |> NativeInput.submit_form(:static, :native)
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
      |> NativeInput.submit_form(:live, :ecto)

    assert has_text?(session, "can't be blank")
  end

  feature "live form - fill required fields then submit shows values in toast", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.fill_input_via_script("native-input-form-name", "Alice", :live)
    |> NativeInput.fill_input_via_script("native-input-form-email", "alice@example.com", :live)
    |> NativeInput.fill_input_via_script("native-input-form-bio", "Developer", :live)
    |> NativeInput.fill_input_via_script("native-input-form-count", "42", :live)
    |> NativeInput.select_option("native-input-form-role", "admin", :live)
    |> NativeInput.click_agree(:live)
    |> NativeInput.submit_form(:live, :ecto)
    |> NativeInput.see_flash("name=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> NativeInput.goto_form(:static)
    |> NativeInput.check_accessibility()
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.check_accessibility()
  end
end
