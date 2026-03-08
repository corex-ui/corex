defmodule E2eWeb.RadioGroupFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.RadioGroupModel, as: RadioGroup

  feature "static form - submit includes choice", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.wait(500)
    |> RadioGroup.submit_form()
    |> RadioGroup.wait(500)
    |> RadioGroup.see_flash("Submitted: choice=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> RadioGroup.goto_form(:static)
    |> RadioGroup.wait(500)
    |> RadioGroup.check_accessibility()
  end

  feature "live form - submit includes choice", %{session: session} do
    session
    |> RadioGroup.goto_form(:live)
    |> RadioGroup.wait(500)
    |> RadioGroup.submit_form(:live)
    |> RadioGroup.wait(2000)
    |> RadioGroup.see_flash("choice=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> RadioGroup.goto_form(:live)
    |> RadioGroup.wait(500)
    |> RadioGroup.check_accessibility()
  end
end
