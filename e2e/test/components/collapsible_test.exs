defmodule E2eWeb.CollapsibleTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.CollapsibleModel, as: Collapsible
  alias E2eWeb.ComponentBehaviorSpec

  @moduletag :collapsible

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "each section toggles open on trigger click", %{session: session} do
      session = ComponentBehaviorSpec.visit_ready(session, Collapsible, :collapsible, :anatomy)

      Enum.reduce(Collapsible.anatomy_section_ids(), session, fn section_id, sess ->
        host = Collapsible.host_id_for_anatomy_section(section_id)

        sess =
          sess
          |> Collapsible.wait_section_collapsible_ready(section_id)
          |> Collapsible.click_trigger_in_host(host)

        assert Collapsible.trigger_data_state_in_host(sess, host) == "open"
        sess
      end)
    end
  end

  describe "api" do
    feature "client binding  -  Open expands panel", %{session: session} do
      host = "collapsible-api"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Collapsible, :collapsible, :api)
        |> Collapsible.wait_host_collapsible_ready(host)

      session
      |> Collapsible.click_in_section("collapsible-api-client", "Open")
      |> Collapsible.wait_trigger_state_in_host(host, "open", timeout: 8_000)
    end
  end

  describe "events" do
    feature "server  -  open appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Collapsible, :collapsible, :events)
        |> Collapsible.prepare_live_form()
        |> Collapsible.wait_host_collapsible_ready("collapsible-events-server")

      refute Collapsible.collapsible_events_server_log_has_row?(session)

      session
      |> Collapsible.click_trigger_in_host("collapsible-events-server")
      |> Collapsible.wait_for_has(
        css("#collapsible-events-log-server tr[data-part='row']"),
        timeout: 10_000
      )

      assert Collapsible.collapsible_events_server_log_has_row?(session)
    end
  end

  describe "patterns" do
    feature "controlled  -  trigger toggles open state", %{session: session} do
      host = "patterns-collapsible-controlled"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Collapsible, :collapsible, :patterns)
        |> Collapsible.wait_patterns_page()
        |> Collapsible.wait_host_collapsible_ready(host)

      assert Collapsible.trigger_data_state_in_host(session, host) == "closed"

      session =
        session
        |> Collapsible.click_trigger_in_host(host)
        |> Collapsible.wait_trigger_state_in_host(host, "open", timeout: 8_000)

      assert Collapsible.trigger_data_state_in_host(session, host) == "open"
    end

    feature "async  -  collapsible mounts after load", %{session: session} do
      session
      |> ComponentBehaviorSpec.visit_ready(Collapsible, :collapsible, :patterns)
      |> Collapsible.wait_host_collapsible_ready("patterns-collapsible-async", timeout: 20_000)
      |> Collapsible.click_trigger_in_host("patterns-collapsible-async")
      |> Collapsible.wait_trigger_state_in_host("patterns-collapsible-async", "open",
        timeout: 8_000
      )
    end
  end
end
