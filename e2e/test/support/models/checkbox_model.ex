defmodule E2eWeb.CheckboxModel do
  use E2eWeb.Model, component: "checkbox"

  @anatomy_sections ~w(
    checkbox-anatomy-minimal
    checkbox-anatomy-labeled
    checkbox-anatomy-invalid
    checkbox-anatomy-indeterminate
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_playground_checkbox_ready(session) do
    assert_has(
      session,
      css("#checkbox-playground[phx-hook='Checkbox']:not([data-loading])", visible: :any)
    )

    session
  end

  def click_playground_checkbox_control(session) do
    session
    |> assert_has(
      css("#checkbox-playground[phx-hook='Checkbox']:not([data-loading])", visible: :any)
    )
    |> click(
      css(
        "#checkbox-playground [data-scope='checkbox'][data-part='control']",
        visible: :any
      )
    )
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#checkbox-patterns-page", visible: :any))
    session
  end

  def control_data_state(session, checkbox_dom_id) when is_binary(checkbox_dom_id) do
    el =
      find(
        session,
        css(~s|[id="checkbox:#{checkbox_dom_id}:control"]|, visible: :any)
      )

    Wallaby.Element.attr(el, "data-state")
  end

  def focus_checkbox_control(session, checkbox_dom_id) when is_binary(checkbox_dom_id) do
    if not (String.match?(checkbox_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(checkbox_dom_id) > 0) do
      raise ArgumentError, "invalid checkbox dom id"
    end

    _ =
      Wallaby.Browser.execute_script(
        session,
        """
        var el = document.getElementById('checkbox:' + arguments[0] + ':control');
        if (el) el.focus();
        """,
        [checkbox_dom_id]
      )

    session
  end

  def press_space_on_checkbox_control(session, checkbox_dom_id) do
    session
    |> focus_checkbox_control(checkbox_dom_id)
    |> press_space()
  end

  def click_api_dispatch_checked(session) do
    session =
      assert_has(
        session,
        css("#checkbox-api-js-dispatch [phx-hook='Checkbox']:not([data-loading])", visible: :any)
      )

    click(
      session,
      xpath(
        "//*[@id='checkbox-api-js-dispatch']//button[contains(normalize-space(), 'Dispatch checked')]"
      )
    )

    session
  end

  def click_api_server_set_checked(session) do
    session =
      assert_has(
        session,
        css(
          "#checkbox-api-server-section [phx-hook='Checkbox']:not([data-loading])",
          visible: :any,
            minimum: 1
        )
      )

    click(
      session,
      xpath(
        "//*[@id='checkbox-api-server-section']//button[contains(normalize-space(), 'Set checked')]"
      )
    )

    session
  end

  def click_events_client_checkbox(session) do
    session =
      assert_has(
        session,
        css("#checkbox-events-client [phx-hook='Checkbox']:not([data-loading])", visible: :any)
      )

    click(
      session,
      css(
        "#checkbox-events-client #checkbox-on-checked-change-client [data-scope='checkbox'][data-part='control']"
      )
    )

    session
  end

  def checkbox_events_client_log_has_row?(session) do
    has?(session, css("#checkbox-events-log-client tr[data-part='row']"))
  end

  def click_control_in_section(session, section_dom_id) do
    session
    |> assert_has(css("##{section_dom_id} [phx-hook='Checkbox']:not([data-loading])"))
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

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
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
    if mode == :live, do: prepare_live_form(session), else: session
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

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "checkbox-form-live-submit", else: "checkbox-form-submit"
    click(session, css("##{id}"))
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

  def wait_static_form_checkbox_ready(session, section_id) when is_binary(section_id) do
    if not (String.match?(section_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(section_id) > 0) do
      raise ArgumentError, "invalid section id"
    end

    assert_has(
      session,
      css("##{section_id} [phx-hook='Checkbox']:not([data-loading])", visible: :any)
    )

    session
  end

  def submit_static_changeset(session) do
    click(session, css("#checkbox-changeset-submit"))
  end

  def submit_static_validate(session) do
    click(session, css("#checkbox-validate-submit"))
  end

  def click_live_strict_submit(session) do
    click(session, css("#checkbox-live-form-validate [type='submit']"))
  end
end
