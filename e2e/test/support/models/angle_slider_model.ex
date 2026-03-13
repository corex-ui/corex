defmodule E2eWeb.AngleSliderModel do
  use E2eWeb.Model, component: "angle-slider"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/angle-slider/form"
        :live -> "/en/live/angle-slider/form"
      end

    visit(session, path)
  end

  def set_angle_value(session, value) do
    input_id = "angle-slider:angle-slider-form-angle:input"
    value_str = to_string(value)

    script = """
    (function() {
      var el = document.getElementById('#{input_id}');
      if (!el) return 'not found';
      el.value = '#{value_str}';
      el.dispatchEvent(new Event('input', { bubbles: true }));
      el.dispatchEvent(new Event('change', { bubbles: true }));
      return 'ok';
    })()
    """

    Wallaby.Browser.execute_script(session, script)
    session
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "angle-slider-form-live-submit", else: "angle-slider-form-submit"
    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
