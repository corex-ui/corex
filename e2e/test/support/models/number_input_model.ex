defmodule E2eWeb.NumberInputModel do
  use E2eWeb.Model, component: "number-input"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/number-input/form"
        :live -> "/en/live/number-input/form"
      end

    visit(session, path)
  end

  def fill_number_input(session, value) when is_number(value) do
    fill_number_input(session, to_string(value))
  end

  def fill_number_input(session, value) when is_binary(value) do
    escaped = String.replace(value, "'", "\\'")

    script = """
    (function() {
      var el = document.querySelector('[data-scope="number-input"][data-part="input"]');
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
    id = if mode == :live, do: "number-input-form-live-submit", else: "number-input-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
