defmodule E2eWeb.SwitchModel do
  use E2eWeb.Model, component: "switch"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/switch/form"
        :live -> "/en/live/switch/form"
      end

    visit(session, path)
  end

  def click_switch(session) do
    click(session, css("[data-scope='switch'][data-part='control']"))
  end

  def click_terms_checkbox(session) do
    click(session, css("[data-scope='checkbox'][data-part='control']"))
  end

  def submit_form(session) do
    click(session, button("Submit"))
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
