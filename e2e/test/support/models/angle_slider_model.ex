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

  def wait_section_angle_slider_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css("##{section_dom_id} [phx-hook='AngleSlider']:not([data-loading])", visible: :any)
    )

    session
  end

  def focus_thumb_in_section(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    _ =
      execute_script(
        session,
        """
        const s = document.querySelector(#{Jason.encode!("#" <> section_dom_id)});
        const t = s && s.querySelector('[data-part="thumb"]');
        if (t) t.focus();
        """,
        []
      )

    session
  end

  def goto_form(session, mode) do
    path =
      case mode do
        :static -> "/en/angle-slider/form"
        :live -> "/en/angle-slider/live-form"
      end

    session = visit_path(session, path)
    if mode == :live, do: prepare_live_form(session), else: session
  end

  def wait_static_native_form_angle_slider_ready(session) do
    assert_has(
      session,
      css(
        "#angle-slider-form-controller [phx-hook='AngleSlider']:not([data-loading])",
        visible: :any,
        minimum: 1
      )
    )

    session
  end

  def wait_native_form_root_style_contains(session, value, opts \\ []) when is_number(value) do
    fragment = style_deg_marker(value)
    timeout = Keyword.get(opts, :timeout, 12_000)
    deadline = System.monotonic_time(:millisecond) + timeout
    busy_wait_native_style(session, fragment, deadline)
    session
  end

  defp busy_wait_native_style(session, fragment, deadline) do
    style = native_form_root_style(session)

    if is_binary(style) and String.contains?(style, fragment) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk(
          "expected native form angle slider root style to include #{inspect(fragment)}, got #{inspect(style)}"
        )
      else
        Process.sleep(50)
        busy_wait_native_style(session, fragment, deadline)
      end
    end
  end

  defp native_form_root_style(session) do
    if has?(
         session,
         css("#angle-slider-form-controller [data-scope='angle-slider'][data-part='root']",
           visible: :any
         )
       ) do
      el =
        find(
          session,
          css("#angle-slider-form-controller [data-scope='angle-slider'][data-part='root']",
            visible: :any
          )
        )

      Wallaby.Element.attr(el, "style") || ""
    else
      ""
    end
  end

  defp style_deg_marker(value) when is_number(value) do
    i = round(value * 1.0)
    Integer.to_string(i) <> "deg"
  end

  def set_angle_value(session, value, mode \\ :static) do
    value_str = to_string(value)
    value_float = value * 1.0

    script =
      case mode do
        :static ->
          """
          (function() {
            var el = document.getElementById(#{Jason.encode!("angle-slider-form-angle")});
            if (!el) return;
            el.dispatchEvent(new CustomEvent('corex:angle-slider:set-value', {
              detail: { value: #{Jason.encode!(value_float)} },
              bubbles: false
            }));
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

    session =
      case mode do
        :static ->
          session
          |> wait_static_native_form_angle_slider_ready()
          |> then(fn s ->
            _ = execute_script(s, script, [])
            s
          end)
          |> wait_native_form_root_style_contains(value_float)

        :live ->
          _ = execute_script(session, script, [])
          session
      end

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

  def wait_static_changeset_angle_slider_ready(session) do
    assert_has(
      session,
      css("#angle-slider-form-changeset [phx-hook='AngleSlider']:not([data-loading])",
        visible: :any,
        minimum: 1
      )
    )

    session
  end

  def wait_static_validate_angle_slider_ready(session) do
    assert_has(
      session,
      css("#angle-slider-form-validate [phx-hook='AngleSlider']:not([data-loading])",
        visible: :any,
        minimum: 1
      )
    )

    session
  end

  def submit_static_changeset(session) do
    click(session, css("#angle-slider-form-changeset-submit"))
  end

  def submit_static_validate(session) do
    click(session, css("#angle-slider-form-validate-submit"))
  end

  def submit_live_validate(session) do
    click(session, css("#angle-slider-live-form-validate-submit"))
  end

  def wait_live_validate_angle_section_ready(session) do
    assert_has(
      session,
      css(
        "#angle-slider-live-form-validate [phx-hook='AngleSlider']:not([data-loading])",
        visible: :any,
        minimum: 1
      )
    )

    session
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

  def angle_events_client_log_has_row?(session) do
    has?(session, css("#angle-slider-events-log-client tr[data-part='row']"))
  end

  def wait_playground_angle_slider_ready(session) do
    assert_has(
      session,
      css("#my-angle-slider[phx-hook='AngleSlider']:not([data-loading])", visible: :any)
    )

    session
  end

  def wait_patterns_angle_slider_page(session) do
    assert_has(session, css("#angle-slider-patterns-page", visible: :any))
    session
  end

  def wait_controlled_angle_slider_ready(session) do
    assert_has(
      session,
      css("#my-angle-slider[phx-hook='AngleSlider']:not([data-loading])", visible: :any)
    )

    session
  end

  def angle_api_js_root_style(session) do
    el =
      find(
        session,
        css("#angle-slider-api-set-value-js [data-scope='angle-slider'][data-part='root']",
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "style")
  end

  def angle_api_server_root_style(session) do
    el =
      find(
        session,
        css("#angle-slider-api-set-value-server [data-scope='angle-slider'][data-part='root']",
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "style")
  end

  def click_api_js_set_degrees(session, degrees) when is_integer(degrees) do
    session =
      assert_has(
        session,
        css("#angle-slider-api-set-value-js [phx-hook='AngleSlider']:not([data-loading])",
          visible: :any,
          minimum: 1
        )
      )

    label = "Set to #{degrees}°"

    click(
      session,
      xpath(
        "//*[@id='angle-slider-api-set-value-js']//button[contains(normalize-space(), #{Jason.encode!(label)})]"
      )
    )

    session
  end

  def click_api_server_degrees(session, degrees) when is_integer(degrees) do
    session =
      assert_has(
        session,
        css(
          "#angle-slider-api-set-value-server [phx-hook='AngleSlider']:not([data-loading])",
          visible: :any,
          minimum: 1
        )
      )

    label = "Server: #{degrees}°"

    click(
      session,
      xpath(
        "//*[@id='angle-slider-api-set-value-server']//button[contains(normalize-space(), #{Jason.encode!(label)})]"
      )
    )

    session
  end

  def angle_events_client_dispatch_value(session, host_id, value)
      when is_binary(host_id) and is_number(value) do
    if not (String.match?(host_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_id) > 0) do
      raise ArgumentError, "invalid angle slider host id"
    end

    session =
      assert_has(
        session,
        css("##{host_id}[phx-hook='AngleSlider']:not([data-loading])", visible: :any)
      )

    execute_script(
      session,
      """
      const el = document.getElementById(#{Jason.encode!(host_id)});
      if (el) {
        el.dispatchEvent(new CustomEvent('corex:angle-slider:set-value', {
          detail: { value: #{Jason.encode!(value * 1.0)} },
          bubbles: false
        }));
      }
      """
    )

    session
  end
end
