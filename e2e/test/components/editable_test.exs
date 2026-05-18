defmodule E2eWeb.EditableTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.EditableModel, as: Editable

  @moduletag :editable

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  edit and submit updates preview", %{session: session} do
      host = "editable-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Editable, :editable, :anatomy)
        |> Editable.wait_section_editable_ready("editable-anatomy-minimal")
        |> Editable.click_edit_trigger_in_host(host)
        |> Editable.focus_input_in_host(host)
        |> Editable.type_in_focused_input("Updated name")
        |> Editable.click_submit_trigger_in_host(host)
        |> Editable.wait_preview_contains_in_host(host, "Updated name", timeout: 8_000)

      assert String.contains?(Editable.preview_text_in_host(session, host), "Updated name")
    end

    feature "triggers  -  edit trigger opens input", %{session: session} do
      host = "editable-anatomy-triggers"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Editable, :editable, :anatomy)
        |> Editable.wait_section_editable_ready("editable-anatomy-triggers")
        |> Editable.click_edit_trigger_in_host(host)

      assert_has(
        session,
        css(~s|##{host} [data-scope="editable"][data-part="input"]|, visible: :any)
      )
    end
  end

  describe "api" do
    feature "client binding  -  Alpha updates preview", %{session: session} do
      host = "editable-api-cb"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Editable, :editable, :api)
        |> Editable.wait_host_editable_ready(host)

      session
      |> Editable.click_in_section("editable-api-set-value-client-binding", "Alpha")
      |> Editable.wait_preview_contains_in_host(host, "Alpha", timeout: 8_000)
    end

    feature "server  -  Beta updates preview", %{session: session} do
      host = "editable-api-srv"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Editable, :editable, :api)
        |> Editable.prepare_live_form()
        |> Editable.wait_host_editable_ready(host)

      session
      |> Editable.click_in_section("editable-api-set-value-server", "Beta")
      |> Editable.wait_preview_contains_in_host(host, "Beta", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  value change appends log row", %{session: session} do
      host = "editable-events-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Editable, :editable, :events)
        |> Editable.prepare_live_form()
        |> Editable.wait_host_editable_ready(host)

      refute Editable.editable_events_server_log_has_row?(session)

      session
      |> Editable.click_edit_trigger_in_host(host)
      |> Editable.focus_input_in_host(host)
      |> Editable.type_in_focused_input("Event value")
      |> Editable.click_submit_trigger_in_host(host)
      |> Editable.wait_for_has(
        css("#editable-events-log-server tr[data-part='row']"),
        timeout: 10_000
      )

      assert Editable.editable_events_server_log_has_row?(session)
    end
  end
end
