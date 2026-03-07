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
    click(session, css("#select-form-country [data-part='trigger']"))
  end

  def select_item(session, value) when is_binary(value) do
    click(session, css("[data-scope='select'][data-part='item'][data-value='#{value}']"))
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "select-form-live-submit", else: "select-form-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    assert_has(session, Wallaby.Query.text("#{key}=#{value}"))
  end

  def see_flash(session, flash_text) do
    assert_has(session, Wallaby.Query.text(flash_text))
  end
end
