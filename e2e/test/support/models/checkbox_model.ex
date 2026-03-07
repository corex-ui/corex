defmodule E2eWeb.CheckboxModel do
  use E2eWeb.Model, component: "checkbox"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/checkbox/form"
        :live -> "/en/live/checkbox/form"
      end

    visit(session, path)
  end

  def click_checkbox(session) do
    click(session, css("[data-scope='checkbox'][data-part='control']"))
  end

  def press_space_on_checkbox(session) do
    session
    |> focus_element("#checkbox-form-terms [data-scope='checkbox'][data-part='control']")
    |> then(&Wallaby.Browser.send_keys(&1, [:space]))
  end

  defp focus_element(session, selector) do
    Wallaby.Browser.execute_script(session, "document.querySelector('#{selector}').focus()")
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "checkbox-form-live-submit", else: "checkbox-form-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    assert_has(session, Wallaby.Query.text("#{key}=#{value}"))
  end

  def see_error(session, error_text) do
    assert_has(session, Wallaby.Query.text(error_text))
  end

  def see_flash(session, flash_text) do
    assert_has(session, Wallaby.Query.text(flash_text))
  end
end
