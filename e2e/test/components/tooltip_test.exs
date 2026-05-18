defmodule E2eWeb.TooltipTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.TooltipModel, as: Tooltip

  @moduletag :tooltip

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  hover opens content", %{session: session} do
      section = "tooltip-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tooltip, :tooltip, :anatomy)
        |> Tooltip.wait_section_tooltip_ready(section)
        |> Tooltip.hover_first_trigger_in_section(section)
        |> Tooltip.wait_open_content_in_section(section, timeout: 8_000)

      assert_has(
        session,
        css(
          ~s|section##{section} [data-scope="tooltip"][data-part="content"][data-state="open"]|,
          visible: :any
        )
      )
    end

    feature "with arrow  -  hover opens content", %{session: session} do
      section = "tooltip-anatomy-with-arrow"

      session
      |> ComponentBehaviorSpec.visit_ready(Tooltip, :tooltip, :anatomy)
      |> Tooltip.wait_section_tooltip_ready(section)
      |> Tooltip.hover_first_trigger_in_section(section)
      |> Tooltip.wait_open_content_in_section(section, timeout: 8_000)
    end
  end

  describe "api" do
    feature "client binding  -  Open shows tooltip", %{session: session} do
      host = "tooltip-api-cb"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tooltip, :tooltip, :api)
        |> Tooltip.wait_host_tooltip_ready(host)

      session
      |> Tooltip.click_in_section("tooltip-api-set-open-client-binding", "Open")
      |> Tooltip.wait_open_content_in_host(host, timeout: 8_000)
    end

    feature "server  -  Open shows tooltip", %{session: session} do
      host = "tooltip-api-srv"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tooltip, :tooltip, :api)
        |> Tooltip.prepare_live_form()
        |> Tooltip.wait_host_tooltip_ready(host)

      session
      |> Tooltip.click_in_section("tooltip-api-set-open-server", "Open")
      |> Tooltip.wait_open_content_in_host(host, timeout: 8_000)
    end
  end

  describe "events" do
    feature "open change  -  open appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Tooltip, :tooltip, :events)
        |> Tooltip.prepare_live_form()
        |> Tooltip.wait_host_tooltip_ready("tooltip-events")

      refute Tooltip.tooltip_events_log_has_row?(session)

      session
      |> Tooltip.hover_first_trigger_in_section("tooltip-events-section")
      |> Tooltip.wait_for_has(css("#tooltip-events-log tr[data-part='row']"), timeout: 10_000)

      assert Tooltip.tooltip_events_log_has_row?(session)
    end
  end

  describe "patterns" do
    feature "multi-trigger  -  hover opens tooltip content", %{session: session} do
      section = "tooltip-pattern-multi-trigger-lv"

      session
      |> ComponentBehaviorSpec.visit_ready(Tooltip, :tooltip, :patterns)
      |> Tooltip.wait_patterns_page()
      |> Tooltip.wait_section_tooltip_ready(section)
      |> Tooltip.hover_first_trigger_in_section(section)
      |> Tooltip.wait_open_content_in_section(section, timeout: 8_000)
    end
  end
end
