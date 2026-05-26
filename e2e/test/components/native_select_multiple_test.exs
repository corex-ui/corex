defmodule E2eWeb.NativeSelectMultipleTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.NativeInputModel, as: NativeInput

  feature "submit without selection shows empty tags", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.fill_all_fields(:live, :ecto)
    |> NativeInput.select_multiple_options("native-input-form-tags", [], :live)
    |> NativeInput.submit_form(:live, :ecto)
    |> NativeInput.see_flash("Submitted:")
    |> NativeInput.see_flash("tags=[]")
  end

  feature "select multiple options and submit shows selected tags", %{session: session} do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.fill_all_fields(:live, :ecto)
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
