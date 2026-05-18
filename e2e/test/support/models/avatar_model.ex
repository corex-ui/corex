defmodule E2eWeb.AvatarModel do
  use E2eWeb.Model, component: "avatar"

  import Wallaby.Query

  @anatomy_sections ~w(
    avatar-anatomy-basic
    avatar-anatomy-custom-slots
  )

  def anatomy_section_ids, do: @anatomy_sections

  def valid_section_dom_id?(section_dom_id) do
    String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and String.length(section_dom_id) > 0
  end

  def scroll_section_into_view(session, section_dom_id) do
    if not valid_section_dom_id?(section_dom_id),
      do: raise(ArgumentError, "invalid section dom id")

    _ =
      execute_script(
        session,
        """
        const el = document.querySelector(arguments[0]);
        if (el) el.scrollIntoView({block: 'center'});
        """,
        ["section#" <> section_dom_id]
      )

    session
  end

  def wait_host_avatar_ready(session, host_dom_id, opts \\ []) do
    if not valid_section_dom_id?(host_dom_id), do: raise(ArgumentError, "invalid host dom id")

    timeout = Keyword.get(opts, :timeout)

    q =
      css(~s|##{host_dom_id}[phx-hook="Avatar"]:not([data-loading])|, visible: :any)

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def wait_section_avatar_ready(session, section_dom_id, opts \\ []) do
    if not valid_section_dom_id?(section_dom_id),
      do: raise(ArgumentError, "invalid section dom id")

    session = scroll_section_into_view(session, section_dom_id)
    timeout = Keyword.get(opts, :timeout)

    q =
      css(
        ~s|section##{section_dom_id} [phx-hook="Avatar"]:not([data-loading])|,
        visible: :any
      )

    case timeout do
      nil -> assert_has(session, q)
      max_ms when is_integer(max_ms) and max_ms > 0 -> wait_for_has(session, q, timeout: max_ms)
    end

    session
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    session = scroll_section_into_view(session, section_id)

    click(
      session,
      xpath("//*[@id='#{section_id}']//button[normalize-space(.)='#{button_label}']")
    )

    session
  end

  def avatar_image_visible?(session, host_dom_id) do
    has?(
      session,
      css(
        ~s|##{host_dom_id} [data-scope="avatar"][data-part="image"][src]:not([src=""])|,
        visible: :any
      )
    )
  end

  def avatar_fallback_visible?(session, host_dom_id) do
    has?(
      session,
      css(~s|##{host_dom_id} [data-scope="avatar"][data-part="fallback"]|, visible: :any)
    )
  end

  def avatar_events_log_has_row?(session) do
    has?(session, css("#avatar-events-log tr[data-part='row']"))
  end
end
