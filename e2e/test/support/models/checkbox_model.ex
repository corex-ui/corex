defmodule E2eWeb.CheckboxModel do
  use E2eWeb.Model, component: "checkbox"

  @anatomy_sections ~w(
    checkbox-anatomy-minimal
    checkbox-anatomy-labeled
    checkbox-anatomy-invalid
  )

  def anatomy_section_ids, do: @anatomy_sections

  def click_control_in_section(session, section_dom_id) do
    session
    |> wait_for_has(css("##{section_dom_id} [phx-hook='Checkbox']:not([data-loading])"),
      timeout: 10_000
    )
    |> click(css("##{section_dom_id} [data-scope='checkbox'][data-part='control']"))
  end

  def click_api_set_unchecked(session) do
    click(
      session,
      Wallaby.Query.xpath(
        "//*[@id='checkbox-api-client-binding']//button[contains(normalize-space(), 'Set unchecked')]"
      )
    )

    session
  end

  def checkbox_events_server_log_has_row?(session) do
    has?(session, css("#checkbox-events-log-server tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/checkbox/form"
        :live -> "/en/checkbox/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form_for_push_toast(session), else: session
  end

  def click_checkbox(session, :live) do
    click(session, css("#checkbox-form-live-terms [data-part='control']"))
  end

  def click_checkbox(session) do
    click(
      session,
      css("#checkbox-form-controller [data-scope='checkbox'][data-part='control']")
    )
  end

  def press_space_on_checkbox(session) do
    session
    |> focus_element("[data-scope='checkbox'][data-part='control']")
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
    wait_for_text(session, "#{key}=#{value}")
  end

  def see_error(session, error_text) do
    wait_for_text(session, error_text)
  end

  def see_flash(session, flash_text) do
    wait_for_flash(session, flash_text)
  end
end
