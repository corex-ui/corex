defmodule E2eWeb.TimerTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

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
    feature "remount  -  countdown timer mounts", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Timer, :timer, :api)
        |> Timer.click_in_section("timer-api-remount", "Remount")
        |> Timer.wait_host_timer_ready("timer-api-remount", timeout: 12_000)

      assert Timer.timer_area_visible_in_host?(session, "timer-api-remount")
    end
  end

  describe "events" do
    feature "server  -  tick appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Timer, :timer, :events)
        |> Timer.prepare_live_form()
        |> Timer.wait_host_timer_ready("timer-events-server")

      refute Timer.timer_events_server_log_has_row?(session)

      session
      |> Timer.click_start_trigger_in_host("timer-events-server")
      |> Timer.wait_for_has(css("#timer-events-log-server tr[data-part='row']"), timeout: 12_000)

      assert Timer.timer_events_server_log_has_row?(session)
    end
  end
end
