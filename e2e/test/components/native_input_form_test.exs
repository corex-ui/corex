defmodule E2eWeb.NativeInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.NativeInputModel, as: NativeInput

  feature "static native form - submit empty shows flash with name and agree", %{session: session} do
    session
    |> NativeInput.goto_form(:static, :native)
    |> NativeInput.submit_form(:static, :native)
    |> NativeInput.wait_for_redirect()
    |> NativeInput.see_flash("Submitted:")
  end

  feature "static native form - fill all native input types then submit shows all values in flash",
          %{
            session: session
          } do
    session
    |> NativeInput.goto_form(:static, :native)
    |> NativeInput.fill_all_fields(:static, :native)
    |> NativeInput.submit_form(:static, :native)
    |> NativeInput.wait_for_redirect()
    |> NativeInput.see_flash("Submitted:")
    |> NativeInput.see_flash("name=")
    |> NativeInput.see_flash("size=")
  end

  feature "static ecto form - submit without required fields shows validation errors", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:static, :ecto)
    |> NativeInput.submit_form(:static, :ecto)
    |> NativeInput.wait_for_ecto_form_error()
  end

  feature "static ecto form - fill all fields then submit shows values in flash", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:static, :ecto)
    |> NativeInput.fill_all_fields(:static, :ecto)
    |> NativeInput.submit_form(:static, :ecto)
    |> NativeInput.wait_for_redirect()
    |> NativeInput.see_flash("Submitted:")
    |> NativeInput.see_flash("size=")
  end

  feature "static ecto form - radio selection persists after failed submit", %{session: session} do
    session
    |> NativeInput.goto_form(:static, :ecto)
    |> NativeInput.click_radio("l", :static, :ecto)
    |> NativeInput.submit_form(:static, :ecto)
    |> NativeInput.wait_for_ecto_form_error()
    |> NativeInput.fill_all_fields(:static, :ecto)
    |> NativeInput.click_radio("s", :static, :ecto)
    |> NativeInput.submit_form(:static, :ecto)
    |> NativeInput.wait_for_redirect()
    |> NativeInput.see_flash("size=")
  end

  feature "live form - submit without required fields shows validation errors", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.submit_form(:live, :ecto)
    |> NativeInput.wait_for_live_form_error()
  end

  feature "live form - fill required fields then submit shows values in toast", %{
    session: session
  } do
    session
    |> NativeInput.goto_form(:live)
    |> NativeInput.fill_all_fields(:live, :ecto)
    |> NativeInput.submit_form(:live, :ecto)
    |> NativeInput.see_flash("name=")
    |> NativeInput.see_flash("size=")
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
