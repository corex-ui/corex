defmodule E2eWeb.NativeSelectMultipleTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.NativeInputModel, as: NativeInput

  defp fill_required_live_fields(session) do
    session
    |> NativeInput.fill_input_via_script("native-input-form-name", "Test", :live)
    |> NativeInput.fill_input_via_script("native-input-form-email", "test@example.com", :live)
    |> NativeInput.fill_input_via_script("native-input-form-bio", "Dev", :live)
    |> NativeInput.fill_input_via_script("native-input-form-count", "42", :live)
    |> NativeInput.select_option("native-input-form-role", "admin", :live)
    |> NativeInput.click_agree(:live)
  end

  feature "submit without selection shows empty tags", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> fill_required_live_fields()
    |> NativeInput.submit_form(:live, :ecto)
    |> NativeInput.see_flash("Submitted:")
    |> NativeInput.see_flash("tags=")
  end

  feature "select multiple options and submit shows selected tags", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> fill_required_live_fields()
    |> NativeInput.select_multiple_options("native-input-form-tags", ["elixir", "phoenix"], :live)
    |> NativeInput.submit_form(:live, :ecto)
    |> NativeInput.see_flash("Submitted:")
    |> NativeInput.see_flash("elixir")
    |> NativeInput.see_flash("phoenix")
  end

  feature "has no A11y violations", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> A11yAudit.Wallaby.assert_no_violations()
  end
end
