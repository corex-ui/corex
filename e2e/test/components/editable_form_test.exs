defmodule E2eWeb.EditableFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.EditableModel, as: Editable

  feature "static form - submit empty/default includes text", %{session: session} do
    session
    |> Editable.goto_form(:static)
    |> Editable.wait(500)
    |> Editable.submit_form()
    |> Editable.wait(500)
    |> Editable.see_flash("Submitted: text=")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> Editable.goto_form(:static)
    |> Editable.wait(500)
    |> Editable.check_accessibility()
  end

  feature "live form - submit default text", %{session: session} do
    session
    |> Editable.goto_form(:live)
    |> Editable.wait(500)
    |> Editable.submit_form(:live)
    |> Editable.wait(2000)
    |> Editable.see_flash("text=")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> Editable.goto_form(:live)
    |> Editable.wait(500)
    |> Editable.check_accessibility()
  end
end
