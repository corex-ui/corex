defmodule E2eWeb.FileUploadModel do
  use E2eWeb.Model, component: "file-upload"

  import Wallaby.Query
  import Wallaby.Browser

  @anatomy_sections ~W(
    file-upload-anatomy-minimal
    file-upload-anatomy-label
    file-upload-anatomy-custom-slots
  )

  def anatomy_section_ids, do: @anatomy_sections

  def valid_section_dom_id?(section_dom_id) do
    String.match?(section_dom_id, ~r/^[a-zA-Z0-9_-]+$/) and section_dom_id != ""
  end

  def wait_section_file_upload_ready(session, section_dom_id) do
    unless valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    assert_has(
      session,
      css(
        ~s|section##{section_dom_id} [phx-hook="FileUpload"]:not([data-loading])|,
        visible: :any
      )
    )

    session
  end

  def wait_host_file_upload_ready(session, host_dom_id) when is_binary(host_dom_id) do
    unless valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    assert_has(
      session,
      css(~s|##{host_dom_id}[phx-hook="FileUpload"]:not([data-loading])|, visible: :any)
    )

    session
  end

  def click_trigger_in_section(session, section_dom_id) do
    unless valid_section_dom_id?(section_dom_id) do
      raise ArgumentError, "invalid section dom id"
    end

    click(
      session,
      css(
        ~s|section##{section_dom_id} [data-scope="file-upload"][data-part="trigger"]|,
        visible: :any
      )
    )
  end

  def click_trigger_by_host_id(session, host_dom_id) when is_binary(host_dom_id) do
    unless valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    click(
      session,
      css(~s|##{host_dom_id} [data-scope="file-upload"][data-part="trigger"]|, visible: :any)
    )
  end

  def click_in_section(session, section_id, button_label)
      when is_binary(section_id) and is_binary(button_label) do
    if String.contains?(button_label, "'") or String.contains?(button_label, "\"") do
      raise ArgumentError, "click_in_section/3 label must not include quotes"
    end

    click(
      session,
      xpath("(//*[@id=\'#{section_id}\']//button[normalize-space(.)=\'#{button_label}\'])[1]")
    )

    session
  end

  def events_server_log_has_row?(session) do
    has?(session, css("#file-upload-events-log-server tr[data-part='row']"))
  end
end
