defmodule E2eWeb.FileUploadModel do
  @moduledoc """
  Behavior map:

    attach_fixture/2    - attach a fixture file to the hidden input inside a host
    see_file_name/3     - assert a file name appears in the item list
    refute_file_name/3  - assert a file name is gone from the item list
    wait_item_count/3   - wait until the accepted item group has N items
    click_delete_item/3 - click the delete trigger on the first item matching name
  """

  use E2eWeb.Model, component: "file-upload"

  import Wallaby.Query
  import Wallaby.Browser

  @anatomy_sections ~W(
    file-upload-anatomy-minimal
    file-upload-anatomy-label
    file-upload-anatomy-custom-slots
  )

  @fixture_dir Path.expand("../fixtures", __DIR__)

  def anatomy_section_ids, do: @anatomy_sections

  def fixture_path(filename), do: Path.join(@fixture_dir, filename)

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

  def attach_fixture(session, host_dom_id, filename \\ "sample.txt") do
    unless valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    path = fixture_path(filename)

    unless File.exists?(path) do
      raise ArgumentError, "fixture not found: #{path}"
    end

    execute_script(
      session,
      """
      var host = document.getElementById(arguments[0]);
      if (!host) return;
      var input = host.querySelector('[data-scope="file-upload"][data-part="hidden-input"]') ||
                  host.querySelector('input[type="file"]');
      if (input) { input.removeAttribute('hidden'); input.style.display = 'block'; }
      """,
      [host_dom_id]
    )

    session
    |> Wallaby.Browser.attach_file(
      css(~s|##{host_dom_id} input[type="file"]|, visible: :any),
      path: path
    )
  end

  def see_file_name(session, host_dom_id, expected_name, opts \\ []) do
    unless valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    timeout = Keyword.get(opts, :timeout, 8_000)
    deadline = System.monotonic_time(:millisecond) + timeout
    busy_wait_file_name(session, host_dom_id, expected_name, deadline)
    session
  end

  defp busy_wait_file_name(session, host_dom_id, expected_name, deadline) do
    key = {:e2e_fu_name, self(), make_ref()}

    _ =
      execute_script(
        session,
        """
        var host = document.getElementById(arguments[0]);
        if (!host) return false;
        var names = host.querySelectorAll('[data-scope="file-upload"][data-part="item-name"]');
        for (var i = 0; i < names.length; i++) {
          if ((names[i].textContent || '').trim() === arguments[1]) return true;
        }
        return false;
        """,
        [host_dom_id, expected_name],
        fn value -> Process.put(key, value) end
      )

    if Process.delete(key) == true do
      :ok
    else
      if System.monotonic_time(:millisecond) >= deadline do
        raise Wallaby.ExpectationNotMetError,
          message: "expected file name #{inspect(expected_name)} in ##{host_dom_id}"
      else
        Process.sleep(50)
        busy_wait_file_name(session, host_dom_id, expected_name, deadline)
      end
    end
  end

  def refute_file_name(session, host_dom_id, name, opts \\ []) do
    unless valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    q =
      css(
        ~s|##{host_dom_id} [data-scope="file-upload"][data-part="item-name"]|,
        text: name,
        visible: :any
      )

    wait_for_refute_has(session, q, Keyword.put_new(opts, :timeout, 8_000))
    session
  end

  def wait_item_count(session, host_dom_id, count, opts \\ []) do
    unless valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    q =
      css(
        ~s|##{host_dom_id} [data-scope="file-upload"][data-part="item"]|,
        count: count,
        visible: :any
      )

    wait_for_has(session, q, opts)
    session
  end

  def click_delete_item(session, host_dom_id, file_name) do
    unless valid_section_dom_id?(host_dom_id) do
      raise ArgumentError, "invalid host dom id"
    end

    execute_script(
      session,
      """
      var host = document.getElementById(arguments[0]);
      if (!host) return;
      var items = host.querySelectorAll('[data-scope="file-upload"][data-part="item"]');
      for (var i = 0; i < items.length; i++) {
        var nameEl = items[i].querySelector('[data-part="item-name"]');
        if (nameEl && nameEl.textContent.trim() === arguments[1]) {
          var del = items[i].querySelector('[data-part="item-delete-trigger"]');
          if (del) del.click();
          break;
        }
      }
      """,
      [host_dom_id, file_name]
    )

    session
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
