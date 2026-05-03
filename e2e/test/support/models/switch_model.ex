defmodule E2eWeb.SwitchModel do
  use E2eWeb.Model, component: "switch"

  @anatomy_sections ~w(
    switch-anatomy-minimal
    switch-anatomy-labeled
  )

  def anatomy_section_ids, do: @anatomy_sections

  def click_control_in_section(session, section_dom_id) do
    session
    |> assert_has(css("##{section_dom_id} [phx-hook='Switch']:not([data-loading])"))
    |> click(css("##{section_dom_id} [data-scope='switch'][data-part='control']"))
  end

  def click_api_off(session) do
    click(
      session,
      xpath(
        "//*[@id='switch-api-set-checked-client-binding']//button[contains(normalize-space(),'Off')]"
      )
    )

    session
  end

  def switch_events_server_log_has_row?(session) do
    has?(session, css("#switch-events-log-server tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/switch/form"
        :live -> "/en/switch/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def click_switch(session, mode \\ :static) do
    section =
      case mode do
        :live -> "#switch-live-form-changeset"
        _ -> "#switch-form-changeset"
      end

    click(session, css("#{section} [data-scope='switch'][data-part='control']"))
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
    case mode do
      :live ->
        session
        |> assert_has(
          css("#switch-live-form-changeset [phx-hook='Switch']:not([data-loading])")
        )
        |> click(css("#switch-live-form-changeset #switch-form-live-submit"))

      _ ->
        click(session, css("#switch-changeset-submit"))
    end
  end

  def see_submitted_value(session, key, value) do
    assert_has(session, css("body", text: "#{key}=#{value}"))
  end

  def see_error(session, error_text) do
    assert_has(session, css("body", text: error_text))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
