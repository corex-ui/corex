defmodule E2eWeb.DialogTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

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
      |> Dialog.click_in_section("dialog-api-client-binding", "Open")
      |> Dialog.wait_dialog_open_by_host_id("dialog-api", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  opening dialog appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Dialog, :dialog, :events)
        |> Dialog.prepare_live_form()
        |> Dialog.wait_root_dialog_ready("dialog-events-server")

      refute Dialog.dialog_events_log_has_row?(session)

      session
      |> Dialog.open_dialog_by_host_id("dialog-events-server")
      |> Dialog.wait_for_has(css("#dialog-events-log-server tr[data-part='row']", count: 1),
        timeout: 10_000
      )
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
  end
end
