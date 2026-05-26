defmodule E2eWeb.NativeInputModel do
  use E2eWeb.Model, component: "native-input"

  def goto_form(session, mode, section \\ :phoenix) do
    path =
      case {mode, section} do
        {:static, :native} -> "/en/native-input/form#native-input-form-native"
        {:static, :ecto} -> "/en/native-input/form#native-input-form-ecto"
        {:static, _} -> "/en/native-input/form"
        {:live, _} -> "/en/native-input/live-form#native-input-live-form-ecto-section"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  defp id_prefix(:live, _section), do: "native-input-live"
  defp id_prefix(:static, :native), do: "native-input-native"
  defp id_prefix(:static, _section), do: "native-input-form"
  defp id_prefix(_mode, _section), do: "native-input-form"

  def fill_input(session, id, value, mode \\ :static, section \\ :ecto) when is_binary(id) do
    input_id = field_id(id, mode, section)
    fill_in(session, css("##{input_id}"), with: value)
  end

  def fill_input_via_script(session, id, value, mode \\ :static, section \\ :ecto)

  def fill_input_via_script(session, id, value, mode, section) when is_number(value) do
    fill_input_via_script(session, id, to_string(value), mode, section)
  end

  def fill_input_via_script(session, id, value, mode, section) when is_binary(value) do
    input_id = field_id(id, mode, section)
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

  defp field_id(id, mode, section) do
    prefix = id_prefix(mode, section)

    base =
      id
      |> String.replace_prefix("native-input-form-", "")
      |> String.replace_prefix("native-input-native-", "")

    "#{prefix}-#{base}-input"
  end

  def fill_input_by_label(session, label, value) do
    fill_in(session, text_field(label), with: value)
  end

  def click_agree(session, mode \\ :static, section \\ :ecto) do
    host_id =
      case {mode, section} do
        {:live, _} -> "native-input-live-agree"
        {:static, :native} -> "native-input-native-agree"
        _ -> "native-input-form-agree"
      end

    input_id = "#{host_id}-input"

    click(session, css("##{input_id}", visible: :any))
  end

  def select_option(session, id, value, mode \\ :static, section \\ :ecto) do
    input_id = field_id(id, mode, section)
    set_value(session, css("##{input_id}"), value)
  end

  def select_multiple_options(session, id, values, mode \\ :static, section \\ :ecto)
      when is_list(values) do
    input_id = field_id(id, mode, section)
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

  def click_radio(session, value, mode \\ :static, section \\ :ecto) do
    radio_name =
      case {mode, section} do
        {:live, _} -> "profile_ecto[size]"
        {:static, :native} -> "profile[size]"
        _ -> "profile_ecto[size]"
      end

    click(session, css("input[type='radio'][name='#{radio_name}'][value='#{value}']"))
  end

  def submit_form(session, mode \\ :static, form \\ :phoenix) do
    case {mode, form} do
      {:live, :ecto} ->
        click(session, css("#native-input-live-submit"))

      {:live, _} ->
        click(session, css("#native-input-live-form-phoenix button[type='submit']"))

      {:static, :native} ->
        click(session, css("#native-input-native-submit"))

      {:static, :ecto} ->
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

  def fill_all_fields(session, mode, section \\ :ecto) do
    session
    |> fill_input_via_script("native-input-form-name", "Alice", mode, section)
    |> fill_input_via_script("native-input-form-email", "alice@example.com", mode, section)
    |> fill_input_via_script("native-input-form-bio", "Developer", mode, section)
    |> fill_input_via_script("native-input-form-birth-date", "1990-01-15", mode, section)
    |> fill_input_via_script("native-input-form-datetime", "2024-06-15T14:30", mode, section)
    |> fill_input_via_script("native-input-form-reminder-time", "09:00", mode, section)
    |> fill_input_via_script("native-input-form-month", "2024-06", mode, section)
    |> fill_input_via_script("native-input-form-week", "2024-W24", mode, section)
    |> fill_input_via_script("native-input-form-website", "https://example.com", mode, section)
    |> fill_input_via_script("native-input-form-phone", "+1234567890", mode, section)
    |> fill_input_via_script("native-input-form-q", "elixir", mode, section)
    |> fill_input_via_script("native-input-form-color", "#ef4444", mode, section)
    |> fill_input_via_script("native-input-form-count", "42", mode, section)
    |> fill_input_via_script("native-input-form-password", "secret1", mode, section)
    |> select_option("native-input-form-role", "admin", mode, section)
    |> select_multiple_options("native-input-form-tags", ["elixir", "phoenix"], mode, section)
    |> click_radio("l", mode, section)
    |> click_agree(mode, section)
  end
end
