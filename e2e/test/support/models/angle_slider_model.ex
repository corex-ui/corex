defmodule E2eWeb.AngleSliderModel do
  import ExUnit.Assertions

  use E2eWeb.Model, component: "angle-slider"

  @anatomy_sections ~w(
    angle-slider-anatomy-minimal
    angle-slider-anatomy-with-label
    angle-slider-anatomy-custom-slots
    angle-slider-anatomy-compound
  )

  def anatomy_section_ids, do: @anatomy_sections

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/angle-slider/form"
        :live -> "/en/angle-slider/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def set_angle_value(session, value, mode \\ :static) do
    value_str = to_string(value)

    script =
      case mode do
        :static ->
          field_id = "angle-slider-form-angle"
          input_id = "angle-slider:#{field_id}:input"

          """
          (function() {
            var el = document.getElementById(#{Jason.encode!(input_id)});
            if (!el) return;
            el.value = #{Jason.encode!(value_str)};
            el.dispatchEvent(new Event('input', { bubbles: true }));
            el.dispatchEvent(new Event('change', { bubbles: true }));
          })();
          """

        :live ->
          """
          (function() {
            var form = document.getElementById(#{Jason.encode!("angle-slider-basic-form")});
            if (!form) return;
            var el = form.querySelector('input[type=hidden]');
            if (!el) return;
            el.value = #{Jason.encode!(value_str)};
            el.dispatchEvent(new Event('input', { bubbles: true }));
            el.dispatchEvent(new Event('change', { bubbles: true }));
          })();
          """
      end

    _ = execute_script(session, script, [])
    session
  end

  def submit_form(session, mode \\ :static) do
    id =
      if mode == :live,
        do: "angle-slider-live-form-changeset-submit",
        else: "angle-slider-form-submit"

    click(session, css("##{id}"))
  end

  def see_flash(session, flash_text, _opts \\ []) do
    assert_toast(session, flash_text)
  end

  def root_style_in_section(session, section_dom_id) do
    el = find(session, css("##{section_dom_id} [data-scope='angle-slider'][data-part='root']"))
    Wallaby.Element.attr(el, "style")
  end

  def dispatch_set_value_in_section(session, section_dom_id, value) when is_number(value) do
    execute_script(
      session,
      """
      const s = document.querySelector(#{Jason.encode!("#" <> section_dom_id)});
      const h = s && s.querySelector('[phx-hook="AngleSlider"]');
      const v = #{Jason.encode!(value * 1.0)};
      if (h) {
        h.dispatchEvent(new CustomEvent('corex:angle-slider:set-value', { detail: { value: v }, bubbles: false }));
      }
      """
    )

    session
  end

  def assert_root_style_contains(session, section_dom_id, substring) do
    style = root_style_in_section(session, section_dom_id)
    assert String.contains?(style, substring)
    session
  end

  def click_set_to_zero_api(session) do
    click(
      session,
      Wallaby.Query.xpath(
        "//*[@id='angle-slider-api-set-value-binding']//button[contains(normalize-space(), 'Set to 0')]"
      )
    )

    session
  end

  def angle_api_root_style(session) do
    el =
      find(
        session,
        css("#angle-slider-api-set-value-binding [data-scope='angle-slider'][data-part='root']")
      )

    Wallaby.Element.attr(el, "style")
  end

  def angle_events_server_dispatch(session) do
    session =
      assert_has(
        session,
        css(
          "#events-angle-slider-on-value-change-server[phx-hook='AngleSlider']:not([data-loading])"
        )
      )

    execute_script(
      session,
      """
      const el = document.getElementById('events-angle-slider-on-value-change-server');
      if (el) {
        el.dispatchEvent(new CustomEvent('corex:angle-slider:set-value', {
          detail: { value: 45.0 },
          bubbles: false
        }));
      }
      """
    )

    session
  end

  def angle_events_server_log_has_row?(session) do
    has?(session, css("#angle-slider-events-log-server tr[data-part='row']"))
  end
end
