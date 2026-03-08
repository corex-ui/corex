defmodule E2eWeb.PasswordInputFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.PasswordInputModel, as: PasswordInput

  feature "static form - submit includes password", %{session: session} do
    session
    |> PasswordInput.goto_form(:static)
    |> PasswordInput.wait(500)
    |> PasswordInput.submit_form()
    |> PasswordInput.wait(500)
    |> PasswordInput.see_flash("Submitted: password=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> PasswordInput.goto_form(:static)
    |> PasswordInput.wait(500)
    |> PasswordInput.check_accessibility()
  end

  feature "live form - submit includes password", %{session: session} do
    session
    |> PasswordInput.goto_form(:live)
    |> PasswordInput.wait(500)
    |> PasswordInput.submit_form(:live)
    |> PasswordInput.wait(2000)
    |> PasswordInput.see_flash("password=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> PasswordInput.goto_form(:live)
    |> PasswordInput.wait(500)
    |> PasswordInput.check_accessibility()
  end
end
