defmodule E2eWeb.MarqueeTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.MarqueeModel, as: Marquee

  @moduletag :marquee

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section mounts marquee host", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Marquee, :marquee, :anatomy)

      Enum.each(Marquee.anatomy_section_ids(), fn section_id ->
        Marquee.wait_section_marquee_ready(session, section_id, timeout: 10_000)
      end)
    end
  end

  describe "api" do
    feature "pause (binding)  -  host becomes paused", %{session: session} do
      host = "api-pause-client"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Marquee, :marquee, :api)
        |> Marquee.wait_host_marquee_ready(host)

      refute Marquee.host_paused?(session, host)

      session =
        session
        |> Marquee.click_in_section("marquee-api-pause-binding", "Pause")
        |> Marquee.wait_host_paused(host, timeout: 8_000)

      assert Marquee.host_paused?(session, host)
    end

    feature "pause (server)  -  host becomes paused", %{session: session} do
      host = "api-pause-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Marquee, :marquee, :api)
        |> Marquee.prepare_live_form()
        |> Marquee.wait_host_marquee_ready(host)

      session =
        session
        |> Marquee.click_in_section("marquee-api-pause-server", "Pause")
        |> Marquee.wait_host_paused(host, timeout: 8_000)

      assert Marquee.host_paused?(session, host)
    end
  end

  describe "events" do
    feature "server  -  pause appends log row", %{session: session} do
      host = "marquee-events-server"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Marquee, :marquee, :events)
        |> Marquee.prepare_live_form()
        |> Marquee.wait_host_marquee_ready(host)

      before = Marquee.log_row_count(session, "marquee-events-log-server")

      session
      |> Marquee.pause_host(host)
      |> Marquee.wait_host_paused(host, timeout: 8_000)
      |> Marquee.wait_log_rows_grew("marquee-events-log-server", before, timeout: 10_000)
    end
  end
end
