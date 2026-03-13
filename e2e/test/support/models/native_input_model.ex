defmodule E2eWeb.NativeInputModel do
  use E2eWeb.Model, component: "native-input"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/native-input/form"
        :live -> "/en/live/native-input/form"
      end

    visit(session, path)
  end

  def fill_input(session, id, value) when is_binary(id) do
    input_id = if String.ends_with?(id, "-input"), do: id, else: "#{id}-input"
    fill_in(session, css("##{input_id}"), with: value)
  end

  def fill_input_via_script(session, id, value) when is_number(value) do
    fill_input_via_script(session, id, to_string(value))
  end

  def fill_input_via_script(session, id, value) when is_binary(value) do
    input_id = if String.ends_with?(id, "-input"), do: id, else: "#{id}-input"
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

  def fill_input_by_label(session, label, value) do
    fill_in(session, text_field(label), with: value)
  end

  def click_checkbox(session) do
    click(
      session,
      css("form [data-scope='native-input'][data-part='input'][type='checkbox']")
    )
  end

  def select_option(session, id, value) do
    input_id = if String.ends_with?(id, "-input"), do: id, else: "#{id}-input"
    set_value(session, css("##{input_id}"), value)
  end

  def select_multiple_options(session, id, values) when is_list(values) do
    input_id = if String.ends_with?(id, "-input"), do: id, else: "#{id}-input"
    values_js = inspect(values)

    script = """
    (function() {
      var select = document.getElementById('#{input_id}');
      if (!select) return 'select not found';
      var values = #{values_js};
      for (var i = 0; i < select.options.length; i++) {
        select.options[i].selected = values.indexOf(select.options[i].value) !== -1;
      }
      select.dispatchEvent(new Event('change', { bubbles: true }));
      return 'ok';
    })()
    """

    Wallaby.Browser.execute_script(session, script)
    session
  end

  def click_radio(session, name, value) do
    click(session, css("input[type='radio'][name='#{name}'][value='#{value}']"))
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "native-input-form-live-submit", else: "native-input-form-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    wait_for_text(session, "#{key}=#{value}")
  end

  def wait_for_redirect(session) do
    wait_for_text(session, "NativeInput form")
  end

  def see_flash(session, flash_text) do
    wait_for_text(session, flash_text)
  end
end
