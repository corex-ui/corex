defmodule E2eWeb.NumberInputModel do
  use E2eWeb.Model, component: "number-input"

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/number-input/form"
        :live -> "/en/number-input/live-form"
      end

    session = visit_path(session, path)

    if mode == :live do
      prepare_live_form(session)
    else
      session
    end
  end

  def fill_number_input(session, value, mode \\ :static)

  def fill_number_input(session, value, mode) when is_number(value) do
    fill_number_input(session, to_string(value), mode)
  end

  def fill_number_input(session, value, mode) when is_binary(value) do
    form_id =
      case mode do
        :live -> "number-input-live-changeset-form"
        :static -> "number-input-changeset-form"
      end

    visible_q =
      css(~s|##{form_id} input[data-scope="number-input"][data-part="input"]|)

    ready_q = css(~s|##{form_id} [phx-hook="NumberInput"]:not([data-loading])|, visible: :any)

    session
    |> assert_has(ready_q)
    |> click(visible_q)
    |> send_keys(visible_q, [:control, "a"])
    |> send_keys(visible_q, value)
    |> assert_value_synced(form_id, value)
  end

  defp assert_value_synced(session, form_id, expected) do
    enc_form = Jason.encode!(form_id)
    enc_val = Jason.encode!(expected)

    script = """
    return (function () {
      var form = document.getElementById(#{enc_form});
      if (!form) throw new Error("assert_value_synced: form not found: " + #{enc_form});
      var hidden = form.querySelector('input[data-scope="number-input"][data-part="value-input"]');
      if (!hidden) throw new Error("assert_value_synced: hidden value-input not found in #" + #{enc_form});
      var fd = new FormData(form);
      var name = hidden.getAttribute("name");
      var sent = String(fd.get(name));
      var want = String(#{enc_val});
      if (sent !== want && sent !== want + ".0") {
        throw new Error("assert_value_synced: form would submit " + JSON.stringify(sent) + " for " + name + ", expected " + want);
      }
      return sent;
    })();
    """

    Wallaby.Browser.execute_script(session, script)
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "number-input-form-live-changeset-submit",
        else: "number-input-changeset-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text, _opts \\ []) do
    assert_toast(session, flash_text)
  end
end
