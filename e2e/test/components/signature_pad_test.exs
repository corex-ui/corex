defmodule E2eWeb.SignaturePadTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.SignatureModel, as: Signature

  @moduletag :signature_pad

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  stroke adds segment", %{session: session} do
      host = "signature-events-server"

      session
      |> ComponentBehaviorSpec.visit_ready(Signature, :signature_pad, :events)
      |> Signature.prepare_live_form()
      |> Signature.wait_host_signature_ready(host)
      |> Signature.draw_stroke_in_host(host)
      |> Signature.wait_has_segment_in_host(host, timeout: 8_000)
    end

    feature "with label  -  clear removes stroke", %{session: session} do
      host = "signature-events-server"

      session
      |> ComponentBehaviorSpec.visit_ready(Signature, :signature_pad, :events)
      |> Signature.prepare_live_form()
      |> Signature.wait_host_signature_ready(host)
      |> Signature.draw_stroke_in_host(host)
      |> Signature.wait_has_segment_in_host(host, timeout: 8_000)
      |> Signature.click_clear_trigger_in_host(host)
      |> Signature.refute_segment_in_host(host)
    end
  end

  describe "api" do
    feature "client binding  -  Clear removes stroke", %{session: session} do
      host = "signature-api-cb"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Signature, :signature_pad, :api)
        |> Signature.prepare_live_form()
        |> Signature.wait_host_signature_ready(host)
        |> Signature.draw_stroke_in_host(host)
        |> Signature.wait_has_segment_in_host(host, timeout: 8_000)

      session
      |> Signature.click_in_section("signature-api-clear-client-binding", "Clear")
      |> Signature.refute_segment_in_host(host)
    end

    feature "server  -  Clear removes stroke", %{session: session} do
      host = "signature-api-srv"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Signature, :signature_pad, :api)
        |> Signature.prepare_live_form()
        |> Signature.wait_host_signature_ready(host)
        |> Signature.draw_stroke_in_host(host)
        |> Signature.wait_has_segment_in_host(host, timeout: 8_000)

      session
      |> Signature.click_in_section("signature-api-clear-server", "Clear (server)")
      |> Signature.refute_segment_in_host(host)
    end
  end

  describe "events" do
    feature "server  -  draw end appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Signature, :signature_pad, :events)
        |> Signature.prepare_live_form()
        |> Signature.wait_host_signature_ready("signature-events-server")

      session
      |> Signature.draw_stroke_and_wait_for_draw_end_log(
        "signature-events-server",
        "signature-events-log-server",
        timeout: 15_000
      )
    end
  end
end
