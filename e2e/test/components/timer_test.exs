defmodule E2eWeb.TimerTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  @moduletag :wallaby

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.TimerModel, as: Timer

  @moduletag :timer

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  timer area is visible", %{session: session} do
      host = "timer-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Timer, :timer, :anatomy)
        |> Timer.wait_section_timer_ready("timer-anatomy-minimal")

      assert Timer.timer_area_visible_in_host?(session, host)
    end

    feature "with triggers  -  action trigger is clickable", %{session: session} do
      host = "timer-anatomy-controls"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Timer, :timer, :anatomy)
        |> Timer.wait_section_timer_ready("timer-anatomy-with-triggers")
        |> Timer.click_action_trigger_in_host(host)

      assert Timer.timer_area_visible_in_host?(session, host)
    end
  end

  describe "api" do
    feature "controls binding starts timer", %{session: session} do
      section = "timer-api-controls-binding"
      host = "timer-api-controls-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Timer, :timer, :api)
        |> Timer.prepare_live_form()
        |> Timer.wait_host_timer_ready(host)
        |> Timer.click_button_in_section(section, "Start")

      assert Timer.timer_area_visible_in_host?(session, host)
      assert has?(session, Timer.action_trigger_query(host, "pause"))
    end

    feature "state server shows toast", %{session: session} do
      section = "timer-api-state-server-section"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Timer, :timer, :api)
        |> Timer.prepare_live_form()
        |> Timer.wait_host_timer_ready("timer-api-state-server")
        |> Timer.click_button_in_section(section, "Read state")

      Timer.assert_toast(session, "timer-api-state-server")
    end
  end

  describe "events" do
    feature "server  -  tick appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Timer, :timer, :events)
        |> Timer.prepare_live_form()
        |> Timer.wait_host_timer_ready("timer-events-server")

      before = Timer.log_row_count(session, "timer-events-log-server")

      session
      |> Timer.click_start_trigger_in_host("timer-events-server")
      |> Timer.wait_log_rows_grew("timer-events-log-server", before, timeout: 12_000)
    end
  end
end
