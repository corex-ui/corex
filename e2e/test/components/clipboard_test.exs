defmodule E2eWeb.ClipboardTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ClipboardModel, as: Clipboard
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :clipboard

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section copies on trigger click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Clipboard, :clipboard, :anatomy)

      Enum.reduce(Clipboard.anatomy_section_ids(), session, fn section_id, sess ->
        host = Clipboard.host_id_for_anatomy_section(section_id)

        sess
        |> Clipboard.wait_host_clipboard_ready(host)
        |> Clipboard.click_trigger_in_host(host)
        |> Clipboard.wait_trigger_copied_in_host(host, timeout: 8_000)
      end)
    end
  end

  describe "api" do
    feature "client  -  Copy pushes copied state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Clipboard, :clipboard, :api)
        |> Clipboard.wait_host_clipboard_ready("clipboard-api-dispatch")

      session
      |> Clipboard.click_in_section("clipboard-api-dispatch-section", "Copy")
      |> Clipboard.wait_trigger_copied_in_host("clipboard-api-dispatch", timeout: 8_000)
    end

    feature "server  -  Copy pushes copied state", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Clipboard, :clipboard, :api)
        |> Clipboard.prepare_live_form()
        |> Clipboard.wait_host_clipboard_ready("clipboard-api-server")

      session
      |> Clipboard.click_in_section("clipboard-api-server-section", "Push copy")
      |> Clipboard.wait_trigger_copied_in_host("clipboard-api-server", timeout: 8_000)
    end
  end

  describe "events" do
    feature "copy  -  interaction appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Clipboard, :clipboard, :events)
        |> Clipboard.prepare_live_form()
        |> Clipboard.wait_host_clipboard_ready("clipboard-events")

      refute Clipboard.clipboard_events_log_has_row?(session)

      session
      |> Clipboard.click_in_section("clipboard-events-section", "Copy")
      |> Clipboard.wait_for_has(css("#clipboard-events-log tr[data-part='row']"), timeout: 10_000)

      assert Clipboard.clipboard_events_log_has_row?(session)
    end
  end
end
