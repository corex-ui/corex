defmodule E2eWeb.PasswordInputModel do
  use E2eWeb.Model, component: "password-input"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/password-input/form"
        :live -> "/en/live/password-input/form"
      end

    visit(session, path)
  end

  def fill_password_input(session, value) do
    input_id = "p-input-password-input-form-password-input"
    escaped = String.replace(value, "'", "\\'")

    script = """
    (function() {
      var el = document.getElementById('#{input_id}');
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

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live, do: "password-input-form-live-submit", else: "password-input-form-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
