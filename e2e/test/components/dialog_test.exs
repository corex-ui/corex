defmodule E2eWeb.DialogTest do
  @moduledoc """
  Dialog Wallaby behavior regression.

  ## Behavior map

  | Page | Features |
  | --- | --- |
  | anatomy | Open + close each section, assert data-state |
  | api | set_open x3 (binding, JS, server), assert open state |
  | events | server log + client log grow, mention open value |
  | playground | hook mounts |
  | patterns | controlled open, alert focus trap |
  """

  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.DialogModel, as: Dialog

  @moduletag :dialog

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each anatomy section opens dialog by click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Dialog, :dialog, :anatomy)

      Enum.reduce(Dialog.anatomy_section_ids(), session, fn section_id, sess ->
        host = Dialog.host_id_for_anatomy_section(section_id)

        sess
        |> Dialog.wait_root_dialog_ready(host)
        |> Dialog.open_dialog_by_host_id(host)
        |> Dialog.wait_dialog_open_by_host_id(host, timeout: 8_000)
        |> Dialog.close_dialog_by_host_id(host)
        |> Dialog.wait_dialog_closed_by_host_id(host, timeout: 8_000)
      end)
    end
  end

  describe "api" do
    feature "client binding  -  Open Dialog reveals content", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :api)
        |> Dialog.wait_root_dialog_ready("dialog-api")

      session
      |> Dialog.click_button_in_section("dialog-api-client-binding", "Open")
      |> Dialog.wait_dialog_open_by_host_id("dialog-api", timeout: 8_000)
    end

    feature "client JS  -  Open via CustomEvent reveals content", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :api)
        |> Dialog.wait_root_dialog_ready("dialog-api-js")

      session
      |> Dialog.click_button_in_section("dialog-api-client-js", "Open")
      |> Dialog.wait_dialog_open_by_host_id("dialog-api-js", timeout: 8_000)
    end

    feature "server  -  Open via LiveView reveals content", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :api)
        |> Dialog.prepare_live_form()
        |> Dialog.wait_root_dialog_ready("dialog-api-server")

      session
      |> Dialog.click_button_in_section("dialog-api-server-section", "Open")
      |> Dialog.wait_dialog_open_by_host_id("dialog-api-server", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  opening dialog appends log row mentioning open", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :events)
        |> Dialog.prepare_live_form()
        |> Dialog.wait_root_dialog_ready("dialog-events-server")

      refute Dialog.dialog_events_server_log_has_row?(session)

      before = Dialog.log_row_count(session, "dialog-events-log-server")

      session =
        session
        |> Dialog.open_dialog_by_host_id("dialog-events-server")
        |> Dialog.wait_log_rows_grew("dialog-events-log-server", before, timeout: 10_000)

      Dialog.assert_events_log_mentions(session, "dialog-events-log-server", "true")
    end

    feature "client  -  opening dialog appends client log row mentioning open", %{
      session: session
    } do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :events)
        |> Dialog.prepare_live_form()
        |> Dialog.wait_root_dialog_ready("dialog-events-client")

      refute Dialog.dialog_events_client_log_has_row?(session)

      before = Dialog.log_row_count(session, "dialog-events-log-client")

      session =
        session
        |> Dialog.open_dialog_by_host_id("dialog-events-client")
        |> Dialog.wait_log_rows_grew("dialog-events-log-client", before, timeout: 20_000)

      Dialog.assert_events_log_mentions(session, "dialog-events-log-client", "true")
    end
  end

  describe "playground" do
    feature "hook host mounts without data-loading", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :playground)
      |> Dialog.wait_playground_dialog_ready()
    end
  end

  describe "patterns" do
    feature "controlled  -  trigger toggles open state", %{session: session} do
      host = "patterns-dialog-controlled"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :patterns)
        |> Dialog.wait_root_dialog_ready(host)

      session = Dialog.open_dialog_by_host_id(session, host)
      Dialog.wait_dialog_open_by_host_id(session, host, timeout: 8_000)
    end

    feature "alert  -  cancel receives initial focus", %{session: session} do
      host = "patterns-dialog-alert"
      cancel_id = "patterns-dialog-alert-cancel"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :patterns)
        |> Dialog.wait_root_dialog_ready(host)
        |> Dialog.open_dialog_by_host_id(host)
        |> Dialog.wait_dialog_open_by_host_id(host, timeout: 8_000)

      Dialog.assert_active_element_id(session, cancel_id)
    end

    feature "alert  -  trigger receives final focus after close", %{session: session} do
      host = "patterns-dialog-alert"
      cancel_id = "patterns-dialog-alert-cancel"
      trigger_id = "dialog:patterns-dialog-alert:trigger"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :patterns)
        |> Dialog.wait_root_dialog_ready(host)
        |> Dialog.open_dialog_by_host_id(host)
        |> Dialog.wait_dialog_open_by_host_id(host, timeout: 8_000)

      session
      |> click(css("##{cancel_id}"))
      |> Dialog.wait_dialog_closed_by_host_id(host, timeout: 8_000)
      |> Dialog.assert_active_element_id(trigger_id)
    end
  end

  describe "keyboard focus and aria" do
    feature "open moves focus into dialog on anatomy minimal", %{session: session} do
      host = "dialog-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :anatomy)
        |> Dialog.wait_root_dialog_ready(host)
        |> Dialog.open_dialog_by_host_id(host)
        |> Dialog.wait_dialog_open_by_host_id(host, timeout: 8_000)

      Dialog.assert_focus_inside_dialog(session, host)
    end

    feature "escape closes open dialog on anatomy minimal", %{session: session} do
      host = "dialog-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :anatomy)
        |> Dialog.wait_root_dialog_ready(host)
        |> Dialog.open_dialog_by_host_id(host)
        |> Dialog.wait_dialog_open_by_host_id(host, timeout: 8_000)

      assert Dialog.dialog_open?(session, host)

      session = Dialog.press_key_on_active(session, :escape)

      Dialog.wait_dialog_closed_by_host_id(session, host, timeout: 5_000)
      refute Dialog.dialog_open?(session, host)
    end
  end
end
