defmodule E2eWeb.FloatingPanelTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.FloatingPanelModel, as: FloatingPanel

  @moduletag :floating_panel

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "basic  -  trigger opens panel", %{session: session} do
      host = "floating-panel-anatomy"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FloatingPanel, :floating_panel, :anatomy)
        |> FloatingPanel.wait_section_floating_panel_ready("floating-panel-anatomy-basic")
        |> FloatingPanel.click_trigger_in_host(host)
        |> FloatingPanel.wait_trigger_open_in_host(host, timeout: 8_000)

      assert_has(
        session,
        css(~s|##{host} [data-scope="floating-panel"][data-part="content"][data-state="open"]|,
          visible: :any
        )
      )
    end

    feature "no trigger  -  open button expands panel", %{session: session} do
      host = "floating-panel-anatomy-no-trigger"

      session
      |> ComponentBehaviorSpec.visit_ready(FloatingPanel, :floating_panel, :anatomy)
      |> FloatingPanel.wait_host_floating_panel_ready(host)
      |> FloatingPanel.click_by_id("floating-panel-anatomy-no-trigger-open")
      |> FloatingPanel.wait_content_open_in_host(host, timeout: 8_000)
    end
  end

  describe "api" do
    feature "client binding  -  Open expands panel", %{session: session} do
      host = "floating-panel-api-bind"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FloatingPanel, :floating_panel, :api)
        |> FloatingPanel.wait_host_floating_panel_ready(host)

      session
      |> FloatingPanel.click_in_section("floating-panel-api-client-bindings", "Open")
      |> FloatingPanel.wait_trigger_open_in_host(host, timeout: 8_000)
    end

    feature "server  -  Open expands panel", %{session: session} do
      host = "floating-panel-api-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FloatingPanel, :floating_panel, :api)
        |> FloatingPanel.prepare_live_form()
        |> FloatingPanel.wait_host_floating_panel_ready(host)

      session
      |> FloatingPanel.click_in_section("floating-panel-api-server-section", "Open")
      |> FloatingPanel.wait_trigger_open_in_host(host, timeout: 8_000)
    end
  end

  describe "events" do
    feature "open change  -  trigger appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(FloatingPanel, :floating_panel, :events)
        |> FloatingPanel.prepare_live_form()
        |> FloatingPanel.wait_host_floating_panel_ready("fp-events-live")

      refute FloatingPanel.floating_panel_events_log_has_row?(session)

      session
      |> FloatingPanel.click_trigger_in_host("fp-events-live")
      |> FloatingPanel.wait_for_has(
        css("#floating-panel-events-log tr[data-part='row']"),
        timeout: 10_000
      )

      assert FloatingPanel.floating_panel_events_log_has_row?(session)
    end
  end
end
