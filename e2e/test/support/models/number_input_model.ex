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

    q =
      css(
        ~s(##{form_id} input[data-scope="number-input"][data-part="input"]),
        visible: :any
      )

    case mode do
      :live ->
        session
        |> click(q)
        |> send_keys(q, [:control, "a"])
        |> send_keys(q, value)

      :static ->
        enc_form = Jason.encode!(form_id)
        enc_val = Jason.encode!(value)

        script = """
        return (function () {
          var form = document.getElementById(#{enc_form});
          if (!form) return "no-form";
          var hidden = form.querySelector('input[data-scope="number-input"][data-part="value-input"]');
          var visible = form.querySelector('input[data-scope="number-input"][data-part="input"]');
          if (hidden) {
            hidden.value = #{enc_val};
            hidden.dispatchEvent(new Event("input", { bubbles: true }));
            hidden.dispatchEvent(new Event("change", { bubbles: true }));
          }
          if (visible) {
            visible.value = #{enc_val};
            visible.dispatchEvent(new InputEvent("input", { bubbles: true }));
          }
          return hidden ? "ok" : "no-hidden";
        })();
        """

        _ = Wallaby.Browser.execute_script(session, script, [], fn r -> r end)
        session
    end
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
