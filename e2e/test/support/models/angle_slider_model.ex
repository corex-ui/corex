defmodule E2eWeb.AngleSliderModel do
  import ExUnit.Assertions

  use E2eWeb.Model, component: "angle-slider"

  @static_phoenix_section "angle-slider-form-phoenix"
  @static_ecto_section "angle-slider-form-ecto"
  @live_phoenix_section "angle-slider-live-form-phoenix"
  @live_validate_form "angle-slider-validate-form-live"

  @anatomy_sections ~W(
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
    {path, page_id} =
      case mode do
        :static -> {"/en/angle-slider/form", "angle-slider-form-page"}
        :live -> {"/en/angle-slider/live-form", "angle-slider-form-live-page"}
      end

    goto_form_page(session, path, page_id, mode)
  end

  def wait_static_phoenix_angle_slider_ready(session) do
    wait_section_angle_slider_ready(session, @static_phoenix_section)
  end

  def wait_static_native_form_angle_slider_ready(session),
    do: wait_static_phoenix_angle_slider_ready(session)

  def wait_static_changeset_angle_slider_ready(session),
    do: wait_section_angle_slider_ready(session, @static_ecto_section)

  def wait_static_validate_angle_slider_ready(session),
    do: wait_section_angle_slider_ready(session, @static_ecto_section)

  def wait_phoenix_form_root_style_contains(
        session,
        value,
        section_id \\ @static_phoenix_section,
        opts \\ []
      )
      when is_number(value) do
    fragment = style_deg_marker(value)
    timeout = Keyword.get(opts, :timeout, 12_000)
    deadline = System.monotonic_time(:millisecond) + timeout
    busy_wait_section_style(session, section_id, fragment, deadline)
    session
  end

  def wait_native_form_root_style_contains(session, value, opts \\ []) when is_number(value) do
    wait_phoenix_form_root_style_contains(session, value, @static_phoenix_section, opts)
  end

  defp busy_wait_section_style(session, section_id, fragment, deadline) do
    style = section_root_style(session, section_id)

    if is_binary(style) and String.contains?(style, fragment) do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk(
          "expected angle slider root style in ##{section_id} to include #{inspect(fragment)}, got #{inspect(style)}"
        )
      else
        Process.sleep(50)
        busy_wait_section_style(session, section_id, fragment, deadline)
      end
    end
  end

  defp section_root_style(session, section_id) do
    selector = "##{section_id} [data-scope='angle-slider'][data-part='root']"

    if has?(session, css(selector, visible: :any)) do
      el = find(session, css(selector, visible: :any))
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
    value_float = value * 1.0

    section_id =
      case mode do
        :static -> @static_phoenix_section
        :live -> @live_phoenix_section
      end

    session =
      case mode do
        :static ->
          session
          |> wait_static_phoenix_angle_slider_ready()
          |> dispatch_set_value_in_section(section_id, value_float)
          |> wait_phoenix_form_root_style_contains(value_float, section_id)

        :live ->
          session
          |> wait_section_angle_slider_ready(section_id)
          |> dispatch_set_value_in_section(section_id, value_float)
      end

    session
  end

  def submit_form(session, mode \\ :static) do
    form_id = if mode == :live, do: @live_phoenix_section, else: @static_phoenix_section
    click(session, css("##{form_id} button[type='submit']"))
  end

  def submit_static_changeset(session) do
    click(session, css("#angle-slider-form-validate-submit"))
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
        "##{@live_validate_form} [phx-hook='AngleSlider']:not([data-loading])",
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
