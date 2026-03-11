defmodule E2eWeb.SelectModel do
  use E2eWeb.Model, component: "select"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/select/form"
        :live -> "/en/live/select/form"
      end

    visit(session, path)
  end

  def click_select_trigger(session) do
    click(session, css("[data-scope='select'][data-part='trigger']"))
  end

  def click_form_select_trigger(session) do
    click(session, css("#select-form [data-scope='select'][data-part='trigger']"))
  end

  def select_item(session, value) when is_binary(value) do
    click(session, css("[data-scope='select'][data-part='item'][data-value='#{value}']"))
  end

  def set_select_value(session, id, value) do
    hidden_id = if String.ends_with?(id, "-value"), do: id, else: "#{id}-value"

    script = """
    (function() {
      var el = document.getElementById('#{hidden_id}');
      if (!el) return 'not found';
      el.value = '#{value}';
      el.dispatchEvent(new Event('input', { bubbles: true }));
      el.dispatchEvent(new Event('change', { bubbles: true }));
      return 'ok';
    })()
    """

    Wallaby.Browser.execute_script(session, script)
    session
  end

  def submit_form(session, mode \\ :static) do
    id = if mode == :live, do: "select-form-live-submit", else: "select-form-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    wait_for_text(session, "#{key}=#{value}")
  end

  def see_flash(session, flash_text, opts \\ []) do
    wait_for_text(session, flash_text, opts)
  end
end
