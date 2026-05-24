defmodule E2eWeb.NativeInputModel do
  use E2eWeb.Model, component: "native-input"

  @static_native_form "native-input-form-native"
  @live_ecto_form "native-input-live-strict-form"

  def goto_form(session, mode, section \\ :phoenix) do
    path =
      case {mode, section} do
        {:static, :native} -> "/en/native-input/form#native-input-form-native"
        {:static, _} -> "/en/native-input/form"
        {:live, _} -> "/en/native-input/live-form#native-input-live-form-ecto-section"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  defp field_prefix(:live), do: "native-input-strict"
  defp field_prefix(_), do: "native-input-form"

  def fill_input(session, id, value, mode \\ :static) when is_binary(id) do
    input_id = field_id(id, mode)
    fill_in(session, css("##{input_id}"), with: value)
  end

  def fill_input_via_script(session, id, value, mode \\ :static)

  def fill_input_via_script(session, id, value, mode) when is_number(value) do
    fill_input_via_script(session, id, to_string(value), mode)
  end

  def fill_input_via_script(session, id, value, mode) when is_binary(value) do
    input_id = field_id(id, mode)
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

  defp field_id(id, mode) do
    prefix = field_prefix(mode)
    base = String.replace_prefix(id, "native-input-form-", "")
    root = "#{prefix}-#{base}"
    if mode == :live, do: root <> "-input", else: root
  end

  def fill_input_by_label(session, label, value) do
    fill_in(session, text_field(label), with: value)
  end

  def click_agree(session, mode \\ :static) do
    host_id =
      case mode do
        :live -> "native-input-strict-agree"
        _ -> "native-input-form-agree"
      end

    input_id = if mode == :live, do: "#{host_id}-input", else: host_id

    click(session, css("##{input_id}", visible: :any))
  end

  def select_option(session, id, value, mode \\ :static) do
    input_id = field_id(id, mode)
    set_value(session, css("##{input_id}"), value)
  end

  def select_multiple_options(session, id, values, mode \\ :static) when is_list(values) do
    input_id = field_id(id, mode)
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

  def click_radio(session, name, value, mode \\ :static) do
    radio_name =
      case mode do
        :live -> "profile_strict[size]"
        _ -> name
      end

    click(session, css("input[type='radio'][name='#{radio_name}'][value='#{value}']"))
  end

  def submit_form(session, mode \\ :static, form \\ :phoenix) do
    case {mode, form} do
      {:live, :ecto} ->
        click(session, css("#native-input-form-live-strict-submit"))

      {:live, _} ->
        click(session, css("#native-input-live-form-phoenix button[type='submit']"))

      {:static, :native} ->
        click(session, css("#native-input-form-submit"))

      _ ->
        click(session, css("#native-input-form-phoenix button[type='submit']"))
    end
  end

  def see_submitted_value(session, key, value) do
    assert_has(session, css("body", text: "#{key}=#{value}"))
  end

  def wait_for_redirect(session) do
    assert_has(session, css("#native-input-form-page"))
  end

  def see_flash(session, flash_text) do
    assert_toast(session, flash_text)
  end
end
