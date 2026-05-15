defmodule E2eWeb.RadioGroupModel do
  use E2eWeb.Model, component: "radio-group"

  def click_item_in_section(session, section_dom_id, value) do
    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "click_item_in_section: value must not contain quotes"
    end

    _ =
      execute_script(
        session,
        "document.getElementById(#{Jason.encode!(section_dom_id)})?.scrollIntoView({block: 'center'})"
      )

    session
    |> assert_has(
      css(
        "##{section_dom_id} [phx-hook='RadioGroup']:not([data-loading]), ##{section_dom_id}[phx-hook='RadioGroup']:not([data-loading])",
        visible: :any
      )
    )
    |> click(
      css(
        "##{section_dom_id} [data-scope='radio-group'][data-part='item'][data-value='#{value}']"
      )
    )
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
    if mode == :live, do: prepare_live_form(session), else: session
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
    assert_has(session, css("#radio-group-form-page"))
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live, do: "radio-group-form-live-submit", else: "radio-group-controller-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
