defmodule E2eWeb.SelectModel do
  use E2eWeb.Model, component: "select"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/select/form"
        :live -> "/en/live/select/form"
      end

    visit(session, path)
  end

  def click_select_trigger(session) do
    click(session, css("[id='select:select-form-country'] [data-part='control']"))
  end

  def select_item(session, value) when is_binary(value) do
    click(session, css("[id='select:select-form-country'] [data-value='#{value}']"))
  end

  def submit_form(session) do
    click(session, button("Submit"))
  end

  def see_submitted_value(session, key, value) do
    assert_has(session, Wallaby.Query.text("#{key}=#{value}"))
  end

  def see_flash(session, flash_text) do
    assert_has(session, Wallaby.Query.text(flash_text))
  end
end
