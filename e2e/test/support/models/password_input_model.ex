defmodule E2eWeb.PasswordInputModel do
  use E2eWeb.Model, component: "password-input"

  @anatomy_sections ~w(
    password-input-anatomy-basic
    password-input-anatomy-icons
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_password_input_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="PasswordInput"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_password_input_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid password input host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="PasswordInput"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_password_input_ready(session) do
    wait_root_password_input_ready(session, "password-input-playground")
  end

  def fill_input_in_section(session, section_dom_id, value) when is_binary(value) do
    fill_in(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="password-input"][data-part="input"]|,
        visible: :any
      ),
      with: value
    )

    session
  end

  def click_visibility_trigger_in_section(session, section_dom_id) do
    click(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="password-input"][data-part="visibility-trigger"]|,
        visible: :any
      )
    )

    session
  end

  def click_button_in_section(session, section_id, label) when is_binary(label) do
    if String.contains?(label, "'") or String.contains?(label, "\"") do
      raise ArgumentError, "click_button_in_section: label must not include quotes"
    end

    click(
      session,
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{label}']")
    )

    session
  end

  def password_input_events_server_log_has_row?(session) do
    has?(session, css("#password-input-events-log-server tr[data-part='row']"))
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/password-input/form"
        :live -> "/en/password-input/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def fill_password_input(session, value) do
    escaped = String.replace(value, "'", "\\'")

    script = """
    (function() {
      var el = document.getElementById('password-input-native-password');
      if (!el) return 'not found';
      el.value = '#{escaped}';
      el.dispatchEvent(new Event('input', { bubbles: true }));
      el.dispatchEvent(new Event('change', { bubbles: true }));
      return 'ok';
    })()
    """

    Wallaby.Browser.execute_script(session, script)
    session
  end

  def fill_live_password_input(session, value) do
    fill_in(
      session,
      css("#p-input-password-input-live-changeset-input", visible: :any),
      with: value
    )

    session
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "password-input-form-live-submit",
        else: "password-input-controller-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
