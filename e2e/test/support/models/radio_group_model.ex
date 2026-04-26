defmodule E2eWeb.RadioGroupModel do
  use E2eWeb.Model, component: "radio-group"

  def click_item_in_section(session, section_dom_id, value) do
    click(
      session,
      css(
        "##{section_dom_id} [data-scope='radio-group'][data-part='item'][data-value='#{value}']"
      )
    )

    session
  end

  def radio_group_events_server_log_has_row?(session) do
    has?(session, css("#radio-group-events-log-server tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/radio-group/form"
        :live -> "/en/radio-group/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form_for_push_toast(session), else: session
  end

  def click_radio_native(session, value) do
    click(
      session,
      css("#radio-group-plain-form input[type='radio'][value='#{value}']")
    )

    session
  end

  def click_radio_live(session, value) do
    click(
      session,
      css(
        "#radio-group-live-changeset [data-scope='radio-group'][data-part='item'][data-value='#{value}']"
      )
    )

    session
  end

  def click_radio_item(session, value) do
    click_radio_native(session, value)
  end

  def wait_for_redirect(session) do
    wait_for_has(session, css("#radio-group-form-page"), timeout: 10_000)
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live, do: "radio-group-form-live-submit", else: "radio-group-controller-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_flash(session, flash_text)
  end
end
