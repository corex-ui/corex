defmodule E2eWeb.PinInputModel do
  use E2eWeb.Model, component: "pin-input"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/pin-input/form"
        :live -> "/en/live/pin-input/form"
      end

    visit(session, path)
  end

  def fill_pin_input(session, pin) when is_binary(pin) do
    chars = String.graphemes(pin)

    Enum.reduce(Enum.with_index(chars), session, fn {char, idx}, s ->
      input_id = "pin-input:pin-input-form-pin:input:#{idx}"
      escaped = String.replace(char, "'", "\\'")

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

      Wallaby.Browser.execute_script(s, script)
      s
    end)
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "pin-input-form-live-submit", else: "pin-input-form-submit"
    click(session, css("##{id}"))
  end

  def wait_for_redirect(session) do
    wait_for_text(session, "Pin Input form")
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
