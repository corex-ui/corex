defmodule E2eWeb.SliderModel do
  import ExUnit.Assertions

  use E2eWeb.Model, component: "slider"

  @static_phoenix_section "slider-form-phoenix"
  @static_ecto_section "slider-form-ecto"
  @live_phoenix_section "slider-live-form-phoenix"
  @live_validate_form "slider-validate-form-live"

  @anatomy_sections ~W(
    slider-anatomy-basic
    slider-anatomy-range
    slider-anatomy-with-marks
    slider-anatomy-compound
  )

  def anatomy_section_ids, do: @anatomy_sections
  def anatomy_single_section_ids, do: ~W(slider-anatomy-basic slider-anatomy-with-marks slider-anatomy-compound)

  def wait_section_slider_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and
              String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css("##{section_dom_id} [phx-hook='Slider']:not([data-loading])", visible: :any)
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
        :static -> {"/en/slider/form", "slider-form-page"}
        :live -> {"/en/slider/live-form", "slider-form-live-page"}
      end

    goto_form_page(session, path, page_id, mode)
  end

  def wait_static_phoenix_slider_ready(session) do
    wait_section_slider_ready(session, @static_phoenix_section)
  end

  def wait_static_native_form_slider_ready(session),
    do: wait_static_phoenix_slider_ready(session)

  def wait_static_changeset_slider_ready(session),
    do: wait_section_slider_ready(session, @static_ecto_section)

  def wait_static_validate_slider_ready(session),
    do: wait_section_slider_ready(session, @static_ecto_section)

  def wait_phoenix_form_root_style_contains(
        session,
        value,
        section_id \\ @static_phoenix_section,
        opts \\ []
      )
      when is_number(value) do
    fragment = style_value_marker(value)
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
          "expected slider root style in ##{section_id} to include #{inspect(fragment)}, got #{inspect(style)}"
        )
      else
        Process.sleep(50)
        busy_wait_section_style(session, section_id, fragment, deadline)
      end
    end
  end

  defp section_root_style(session, section_id) do
    selector = "##{section_id} [data-scope='slider'][data-part='root']"

    if has?(session, css(selector, visible: :any)) do
      el = find(session, css(selector, visible: :any))
      Wallaby.Element.attr(el, "style") || ""
    else
      ""
    end
  end

  defp style_value_marker(value) when is_number(value) do
    i = trunc(value * 1.0)
    "--slider-thumb-offset-0:#{i}"
  end

  def value_text_in_section(session, section_dom_id) do
    selector = "##{section_dom_id} [data-scope='slider'][data-part='value']"

    if has?(session, css(selector, visible: :any)) do
      el = find(session, css(selector, visible: :any))
      Wallaby.Element.text(el) || ""
    else
      ""
    end
  end

  def wait_value_text_in_section(session, section_dom_id, expected, opts \\ []) do
    timeout = Keyword.get(opts, :timeout, 12_000)
    deadline = System.monotonic_time(:millisecond) + timeout
    expected = to_string(expected)
    busy_wait_value_text(session, section_dom_id, expected, deadline)
    session
  end

  defp busy_wait_value_text(session, section_id, expected, deadline) do
    text = value_text_in_section(session, section_id)

    if text == expected do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        flunk(
          "expected slider value-text in ##{section_id} to be #{inspect(expected)}, got #{inspect(text)}"
        )
      else
        Process.sleep(50)
        busy_wait_value_text(session, section_id, expected, deadline)
      end
    end
  end

  def set_volume_value(session, value, mode \\ :static) do
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
          |> wait_static_phoenix_slider_ready()
          |> dispatch_set_value_in_section(section_id, value_float)
          |> wait_value_text_in_section(section_id, trunc(value_float))

        :live ->
          session
          |> wait_section_slider_ready(section_id)
          |> dispatch_set_value_in_section(section_id, value_float)
          |> wait_value_text_in_section(section_id, trunc(value_float))
      end

    session
  end

  def submit_form(session, mode \\ :static) do
    form_id = if mode == :live, do: @live_phoenix_section, else: @static_phoenix_section
    click(session, css("##{form_id} button[type='submit']"))
  end

  def submit_static_changeset(session) do
    click(session, css("#slider-form-validate-submit"))
  end

  def submit_static_validate(session) do
    click(session, css("#slider-form-validate-submit"))
  end

  def submit_live_validate(session) do
    click(session, css("#slider-live-form-validate-submit"))
  end

  def wait_live_validate_volume_section_ready(session) do
    assert_has(
      session,
      css(
        "##{@live_validate_form} [phx-hook='Slider']:not([data-loading])",
        visible: :any,
        minimum: 1
      )
    )

    session
  end

  def root_style_in_section(session, section_dom_id) do
    el = find(session, css("##{section_dom_id} [data-scope='slider'][data-part='root']"))
    Wallaby.Element.attr(el, "style")
  end

  def dispatch_set_value_in_section(session, section_dom_id, value) do
    encoded = Jason.encode!(normalize_dispatch_value(value))

    execute_script(
      session,
      """
      const s = document.querySelector(#{Jason.encode!("#" <> section_dom_id)});
      const h = s && s.querySelector('[phx-hook="Slider"]');
      const v = #{encoded};
      if (h) {
        h.dispatchEvent(new CustomEvent('corex:slider:set-value', { detail: { value: v }, bubbles: false }));
      }
      """
    )

    session
  end

  defp normalize_dispatch_value(value) when is_list(value), do: Enum.map(value, &(&1 * 1.0))
  defp normalize_dispatch_value(value) when is_number(value), do: value * 1.0

  def assert_root_style_contains(session, section_dom_id, substring) do
    style = root_style_in_section(session, section_dom_id)
    assert String.contains?(style, substring)
    session
  end

  def click_set_to_zero_api(session) do
    click(
      session,
      Wallaby.Query.xpath(
        "//*[@id='slider-api-set-value-binding']//button[contains(normalize-space(), 'Set to 0')]"
      )
    )

    session
  end

  def slider_api_root_style(session) do
    el =
      find(
        session,
        css("#slider-api-set-value-binding [data-scope='slider'][data-part='root']")
      )

    Wallaby.Element.attr(el, "style")
  end

  def slider_events_server_dispatch(session) do
    session =
      assert_has(
        session,
        css(
          "#events-slider-on-value-change-server[phx-hook='Slider']:not([data-loading])"
        )
      )

    execute_script(
      session,
      """
      const el = document.getElementById('events-slider-on-value-change-server');
      if (el) {
        el.dispatchEvent(new CustomEvent('corex:slider:set-value', {
          detail: { value: 45.0 },
          bubbles: false
        }));
      }
      """
    )

    session
  end

  def slider_events_server_log_has_row?(session) do
    has?(session, css("#slider-events-log-server tr[data-part='row']"))
  end

  def slider_events_client_log_has_row?(session) do
    has?(session, css("#slider-events-log-client tr[data-part='row']"))
  end

  def wait_playground_slider_ready(session) do
    assert_has(
      session,
      css("#my-slider[phx-hook='Slider']:not([data-loading])", visible: :any)
    )

    session
  end

  def wait_patterns_slider_page(session) do
    assert_has(session, css("#slider-patterns-page", visible: :any))
    session
  end

  def slider_api_js_root_style(session) do
    el =
      find(
        session,
        css("#slider-api-set-value-js [data-scope='slider'][data-part='root']",
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "style")
  end

  def slider_api_server_root_style(session) do
    el =
      find(
        session,
        css("#slider-api-set-value-server [data-scope='slider'][data-part='root']",
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "style")
  end

  def click_api_js_set_value(session, degrees) when is_integer(degrees) do
    session =
      assert_has(
        session,
        css("#slider-api-set-value-js [phx-hook='Slider']:not([data-loading])",
          visible: :any,
          minimum: 1
        )
      )

    label = "Set to #{degrees}"

    click(
      session,
      xpath(
        "//*[@id='slider-api-set-value-js']//button[contains(normalize-space(), #{Jason.encode!(label)})]"
      )
    )

    session
  end

  def click_api_server_value(session, degrees) when is_integer(degrees) do
    session =
      assert_has(
        session,
        css(
          "#slider-api-set-value-server [phx-hook='Slider']:not([data-loading])",
          visible: :any,
          minimum: 1
        )
      )

    label = "Server: #{degrees}"

    click(
      session,
      xpath(
        "//*[@id='slider-api-set-value-server']//button[contains(normalize-space(), #{Jason.encode!(label)})]"
      )
    )

    session
  end

  def slider_events_client_dispatch_value(session, host_id, value)
      when is_binary(host_id) and is_number(value) do
    if not (String.match?(host_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_id) > 0) do
      raise ArgumentError, "invalid slider host id"
    end

    session =
      assert_has(
        session,
        css("##{host_id}[phx-hook='Slider']:not([data-loading])", visible: :any)
      )

    execute_script(
      session,
      """
      const el = document.getElementById(#{Jason.encode!(host_id)});
      if (el) {
        el.dispatchEvent(new CustomEvent('corex:slider:set-value', {
          detail: { value: #{Jason.encode!(value * 1.0)} },
          bubbles: false
        }));
      }
      """
    )

    session
  end
end
