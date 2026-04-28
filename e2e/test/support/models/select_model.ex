defmodule E2eWeb.SelectModel do
  use E2eWeb.Model, component: "select"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/select/form"
        :live -> "/en/select/live-form"
      end

    session = visit_path(session, path)

    if mode == :live do
      prepare_live_form(session)
    else
      session
    end
  end

  def wait_for_select_field_error(session, mode \\ :static, _opts \\ []) do
    form_id =
      case mode do
        :live -> "select-form"
        :static -> "select-changeset-form"
      end

    q =
      css(~s(##{form_id} [data-scope="select"][data-part="error"]),
        text: "blank"
      )

    assert_has(session, q)
  end

  def click_select_trigger(session) do
    session
    |> assert_has(css("[phx-hook='Select']:not([data-loading])"))
    |> click(css("[data-scope='select'][data-part='trigger']"))
  end

  def click_form_select_trigger(session, mode \\ :static) do
    form_id = if mode == :live, do: "select-form", else: "select-changeset-form"

    session
    |> assert_has(css("##{form_id} [phx-hook='Select']:not([data-loading])"))
    |> click(css("##{form_id} [data-scope='select'][data-part='trigger']"))
  end

  def select_item(session, value) when is_binary(value) do
    session
    |> assert_has(css(~s([data-scope='select'][data-part='content'][data-state='open'])))
    |> click(css("[data-scope='select'][data-part='item'][data-value='#{value}']"))
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
    id = if mode == :live, do: "select-form-live-submit", else: "select-changeset-submit"
    click(session, css("##{id}"))
  end

  def see_submitted_value(session, key, value) do
    assert_has(session, css("body", text: "#{key}=#{value}"))
  end

  def see_flash(session, flash_text, _opts \\ []) do
    assert_toast(session, flash_text)
  end
end
