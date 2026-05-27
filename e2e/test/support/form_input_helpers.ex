defmodule E2eWeb.FormInputHelpers do
  @moduledoc false

  def set_input_value(session, element_id, value) when is_binary(element_id) do
    escaped = String.replace(to_string(value), "'", "\\'")

    script = """
    (function() {
      var el = document.getElementById('#{element_id}');
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

  def set_select_selected_values(session, element_id, values) when is_binary(element_id) do
    values_js = inspect(values)

    script = """
    (function() {
      var select = document.getElementById('#{element_id}');
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

  def scroll_into_view(session, element_id) when is_binary(element_id) do
    Wallaby.Browser.execute_script(
      session,
      "document.getElementById(arguments[0])?.scrollIntoView({block: 'center'})",
      [element_id]
    )

    session
  end
end
