defmodule E2eWeb.EditableFormTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.EditableModel, as: Editable

  feature "static form - submit empty/default includes text", %{session: session} do
    session
    |> Editable.goto_form(:static)
    |> Editable.submit_form()
    |> Editable.see_flash("Submitted: text=")
  end

  feature "static form - submit committed edit", %{session: session} do
    session
    |> Editable.goto_form(:static)
    |> Editable.wait_section_editable_ready("editable-form-phoenix")
    |> Editable.click_edit_trigger_in_host("editable-form-phoenix_text")
    |> Editable.focus_input_in_host("editable-form-phoenix_text")
    |> Editable.type_in_focused_input("hello")
    |> Editable.click_submit_trigger_in_host("editable-form-phoenix_text")
    |> Editable.wait_preview_contains_in_host("editable-form-phoenix_text", "hello")
    |> Editable.submit_form()
    |> Editable.see_flash("hello")
  end

  feature "static form - has no A11y violations", %{session: session} do
    session
    |> Editable.goto_form(:static)
    |> Editable.check_accessibility()
  end

  feature "live form - submit default text", %{session: session} do
    session
    |> Editable.goto_form(:live)
    |> Editable.set_live_form_text("hello")
    |> Editable.submit_form(:live)
    |> Editable.see_flash("text=hello")
  end

  feature "live form - has no A11y violations", %{session: session} do
    session
    |> Editable.goto_form(:live)
    |> Editable.check_accessibility()
  end
end
