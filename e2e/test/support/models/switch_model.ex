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

  def press_space_on_switch(session) do
    session
    |> focus_element("[data-scope='switch'][data-part='control']")
    |> then(&Wallaby.Browser.send_keys(&1, [:space]))
  end

  defp focus_element(session, selector) do
    Wallaby.Browser.execute_script(session, "document.querySelector('#{selector}').focus()")
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "switch-form-live-submit", else: "switch-form-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    wait_for_text(session, "#{key}=#{value}")
  end

  def see_error(session, error_text) do
    wait_for_text(session, error_text)
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
