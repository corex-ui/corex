defmodule E2eWeb.ComboboxModel do
  use E2eWeb.Model, component: "combobox"

  @anatomy_sections ~w(
    combobox-anatomy-minimal
    combobox-anatomy-slots
    combobox-anatomy-labeled
    combobox-anatomy-grouped
    combobox-anatomy-extended
    combobox-anatomy-extended-grouped
  )

  def anatomy_section_ids, do: @anatomy_sections

  def wait_section_combobox_ready(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_root_combobox_ready(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="Combobox"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def wait_playground_combobox_ready(session) do
    wait_root_combobox_ready(session, "combobox-playground")
  end

  def wait_patterns_page(session) do
    assert_has(session, css("#combobox-patterns-page", visible: :any))
    session
  end

  def open_combobox_in_anatomy_section(session, section_dom_id) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    click(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"] [data-scope="combobox"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def open_combobox_by_host_id(session, host_dom_id) when is_binary(host_dom_id) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    click(
      session,
      css(
        ~s|##{host_dom_id}[phx-hook="Combobox"] [data-scope="combobox"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def click_item_in_anatomy_section(session, section_dom_id, value) when is_binary(value) do
    if not (String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(section_dom_id) > 0) do
      raise ArgumentError, "invalid section dom id"
    end

    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    root_sel = "section##{section_dom_id} [phx-hook=\"Combobox\"]"

    _ =
      execute_script(
        session,
        """
        const r = document.querySelector(#{Jason.encode!(root_sel)});
        if (r) r.scrollIntoView({block: 'center'});
        """,
        []
      )

    text_sel =
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"] [data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template]) [data-part="item-text"]|,
        visible: :any
      )

    item_sel =
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"] [data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template])|,
        visible: :any
      )

    q = if has?(session, text_sel), do: text_sel, else: item_sel
    click(session, q)
  end

  def click_item_by_host_id(session, host_dom_id, value) when is_binary(value) do
    if not (String.match?(host_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(host_dom_id) > 0) do
      raise ArgumentError, "invalid combobox host dom id"
    end

    if String.contains?(value, "'") or String.contains?(value, "\"") do
      raise ArgumentError, "value must not contain quotes"
    end

    _ =
      execute_script(
        session,
        """
        const r = document.getElementById(#{Jason.encode!(host_dom_id)});
        if (r) r.scrollIntoView({block: 'center'});
        """,
        []
      )

    text_sel =
      css(
        ~s|##{host_dom_id} [data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template]) [data-part="item-text"]|,
        visible: :any
      )

    item_sel =
      css(
        ~s|##{host_dom_id} [data-scope="combobox"][data-part="item"][data-value="#{value}"]:not([data-template])|,
        visible: :any
      )

    q = if has?(session, text_sel), do: text_sel, else: item_sel
    click(session, q)
  end

  def hidden_input_value_in_anatomy_section(session, section_dom_id) do
    el =
      find(
        session,
        css(
          ~s|section##{section_dom_id} [phx-hook="Combobox"] input[data-scope="combobox"][data-part="hidden-input"]|,
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "value")
  end

  def hidden_input_value_by_host_id(session, host_dom_id) do
    el =
      find(
        session,
        css(
          ~s|##{host_dom_id} input[data-scope="combobox"][data-part="hidden-input"]|,
          visible: :any
        )
      )

    Wallaby.Element.attr(el, "value")
  end

  def wait_hidden_value_in_anatomy_section(session, section_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    wait_for_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="Combobox"] input[data-scope="combobox"][data-part="hidden-input"][value="#{expected}"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def wait_hidden_value_by_host_id(session, host_dom_id, expected, opts \\ [])
      when is_binary(expected) do
    wait_for_has(
      session,
      css(
        ~s|##{host_dom_id} input[data-scope="combobox"][data-part="hidden-input"][value="#{expected}"]|,
        visible: :any
      ),
      opts
    )

    session
  end

  def wait_patterns_state_contains(session, substring, opts \\ []) when is_binary(substring) do
    if String.contains?(substring, "'") do
      raise ArgumentError, "substring must not contain single quote"
    end

    wait_for_has(
      session,
      xpath(
        "//*[@id='combobox-patterns-controlled-state' and contains(., '#{substring}')]"
      ),
      opts
    )

    session
  end

  def click_button_in_section(session, section_id, label) when is_binary(label) do
    if String.contains?(label, "'") or String.contains?(label, "\"") do
      raise ArgumentError, "click_button_in_section: label must not include quotes"
    end

    click(
      session,
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{label}']")
    )

    session
  end

  def controlled_patterns_state_text(session) do
    el = find(session, css("#combobox-patterns-controlled-state"))
    Wallaby.Element.text(el)
  end
end
