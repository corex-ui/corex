defmodule E2eWeb.PasswordInputModel do
  use E2eWeb.Model, component: "password-input"

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
