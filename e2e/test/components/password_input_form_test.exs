defmodule E2eWeb.PasswordInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.PasswordInputModel, as: PasswordInput

  feature "static form - submit empty native password", %{session: session} do
    session
    |> PasswordInput.goto_form(:static)
    |> PasswordInput.submit_form()
    |> PasswordInput.see_flash("Submitted: password=")
  end

  feature "static form - fill native password then submit", %{session: session} do
    session
    |> PasswordInput.goto_form(:static)
    |> PasswordInput.fill_password_input("secret123")
    |> PasswordInput.submit_form()
    |> PasswordInput.see_flash("password=***")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> PasswordInput.goto_form(:static)
    |> PasswordInput.check_accessibility()
  end

  feature "live form - submit empty password does not show success", %{session: session} do
    session =
      session
      |> PasswordInput.goto_form(:live)
      |> PasswordInput.submit_form(:live, :ecto)

    refute_has(session, Wallaby.Query.text("password=***"))
    assert_has(session, Wallaby.Query.css("#password-input-live-form-ecto", visible: true))
  end

  feature "live form - fill password then submit", %{session: session} do
    session
    |> PasswordInput.goto_form(:live)
    |> PasswordInput.fill_live_password_input("secret123", :phoenix)
    |> PasswordInput.submit_form(:live, :phoenix)
    |> PasswordInput.see_flash("password=***")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> PasswordInput.goto_form(:live)
    |> PasswordInput.check_accessibility()
  end
end
