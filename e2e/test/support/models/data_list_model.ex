defmodule E2eWeb.DataListModel do
  use E2eWeb.Model, component: "data-list"

  @anatomy_sections ~w(
    data-list-anatomy-minimal
    data-list-anatomy-manual-slots
    data-list-anatomy-custom-slots
    data-list-anatomy-empty
  )

  @style_sections ~w(
    data-list-styling-color
    data-list-styling-size
    data-list-styling-max-width
  )

  def anatomy_section_ids, do: @anatomy_sections
  def style_section_ids, do: @style_sections

  def see_content(session, content_text) do
    see(session, content_text)
  end

  def see_in_section(session, section_id, content_text)
      when is_binary(section_id) and is_binary(content_text) do
    assert_has(session, css("##{section_id}", text: content_text, minimum: 1))
    session
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{button_label}']")
    )

    session
  end

  def assert_orientation(session, orientation) when orientation in ["vertical", "horizontal"] do
    assert_has(
      session,
      css(
        "#data-list-playground [data-scope='data-list'][data-part='root'][data-orientation='#{orientation}']",
        visible: :any
      )
    )

    session
  end
end
